import Foundation

public struct CPF: FazendinhaNumberProtocol, Generatable {
    public typealias T = CPF

    public let plainNumber: String
    public let maskedNumber: String
    public let checkDigits: [Int]
    public static var checkDigitsCount: Int = 2
    public static var numberLength: Int = 11
    static let weights = [11, 10, 9, 8, 7, 6, 5, 4, 3, 2]
    let validator: Validator
    let parser = Parser()

    /**
     Creates a CPF from a given number
     - Parameter number: CPF number
     - Throws: `InputError.invalidFormat` if the string is not either just 11 numbers (E.g.: XXXXXXXXXXX) or number with
     the CPF mask. (E.g.: XXX.XXX.XXX-XX)
     - Returns: CPF

     */
    public init(number: String) throws {

        let numberParsedInfo = try parser.parse(number: number,
                                                separators: [".", ".", "-"],
                                                steps: [3, 3, 3, 2])

        self.plainNumber = numberParsedInfo.plainNumber
        self.maskedNumber = numberParsedInfo.maskedNumber
        self.checkDigits = numberParsedInfo.checkDigits
        self.validator = Validator(numberParsedInfo: numberParsedInfo)
    }

    public var states: [State] {
        
        return 🇧🇷.states.filter { (state: State) -> Bool in
            return state.fiscalRegion == fiscalRegion
        }
    }

    static let fazendaAlgorythm = Validator.ValidationAlgorythm.fazenda { (basicNumber: String) -> (Int) in
        return T.calcWeightSum(basicNumber: basicNumber)
    }

    public func isValid(validationAlgorythm: Validator.ValidationAlgorythm = CPF.fazendaAlgorythm,
                        allSameDigitsAreValid: Bool = false) -> Bool {

        return validator.isValid(validationAlgorythm: validationAlgorythm,
                                 allSameDigitsAreValid: allSameDigitsAreValid)
    }

    public static func generate() -> CPF {

        let cpf = CPF.generate { (string: String) -> (Int) in
            return CPF.calcWeightSum(basicNumber: string)
        }
        return cpf
    }

    public var fiscalRegion: FiscalRegion {

        let frRange = Range(uncheckedBounds: (plainNumber.index(plainNumber.endIndex, offsetBy: -3),
                                              plainNumber.index(plainNumber.endIndex, offsetBy: -2)))
        let fiscalRegion = FiscalRegion(rawValue: Int(plainNumber.substring(with: frRange))!)!
        return fiscalRegion
    }
}


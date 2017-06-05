import Foundation

public struct CPF: FazendinhaNumberProtocol, Generatable, NumberParsedInfoInterface {
    public typealias T = CPF
    public typealias F = CPF

    public static var checkDigitsCount: Int = 2
    public static var numberLength: Int = 11
    static let weights: [Int] = [11, 10, 9, 8, 7, 6, 5, 4, 3, 2]
    static let separators: [Character] = [".", ".", "-"]
    static let steps: [Int] = [3, 3, 3, checkDigitsCount]
    let validator: Validator
    let parser: Parser = Parser()
    let numberParsedInfo: Parser.Info

    /**
     Creates a CPF from a given number
     - Parameter number: CPF number
     - Throws: `InputError.invalidFormat` if the string is not either just 11 numbers (E.g.: XXXXXXXXXXX) or number with
     the CPF mask. (E.g.: XXX.XXX.XXX-XX)
     - Returns: CPF
     */
    public init(number: String) throws {

        self.numberParsedInfo = try parser.parse(number: number,
                                                 separators: CPF.separators,
                                                 steps: CPF.steps)

        self.validator = Validator(numberParsedInfo: numberParsedInfo)
    }

    public var states: [State] {

        return 🇧🇷.states.filter { (state: State) -> Bool in
            return state.fiscalRegion == fiscalRegion
        }
    }

    public static let fazendaAlgorythm: Validator.ValidationAlgorythm =
        Validator.ValidationAlgorythm.fazenda { (basicNumber: String) -> (Int) in
            return T.calcWeightSum(basicNumber: basicNumber)
        }

    public func isValid(validationAlgorythm: Validator.ValidationAlgorythm = .simple,
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
        // swiftlint:disable force_unwrapping
        let fiscalRegionValue = Int(plainNumber.substring(with: frRange))!
        let fiscalRegion = FiscalRegion(rawValue: fiscalRegionValue)!
        // swiftlint:enable force_unwrapping
        return fiscalRegion
    }
}

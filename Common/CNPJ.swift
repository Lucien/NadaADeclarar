import Foundation

public struct CNPJ: FazendinhaNumberProtocol, Generatable, NumberParsedInfoInterface {

    public typealias T = CNPJ
    public typealias F = CNPJ

    public static let checkDigitsCount = 2
    public static let numberLength = 14
    static let weights = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
    static let separators: [Character] = [".", ".", "/", "-"]
    static let steps = [2, 3, 3, 4, checkDigitsCount]
    let validator: Validator
    let parser = Parser()
    let numberParsedInfo: Parser.Info

    /**
     Creates a CNPJ from a given number
     - Parameter number: CNPJ number
     - Throws: `InputError.invalidFormat` if the string is not either just 14 numbers (E.g.: XXXXXXXXXXXXXX) or number with
     the CPF mask. (E.g.: XX.XXX.XXX/XXXX-XX)
     - Returns: CNPJ
     */
    public init(number: String) throws {

        self.numberParsedInfo = try parser.parse(number: number,
                                                 separators: CNPJ.separators,
                                                 steps: CNPJ.steps)

        self.validator = Validator(numberParsedInfo: numberParsedInfo)
    }

    public var isHeadquarters: Bool {
        return branchNumber == "0001"
    }

    public var branchNumber: String {
        return numberParsedInfo.parts.dropLast().last!
    }

    public func isValid(allSameDigitsAreValid: Bool = false) -> Bool {

        let algorythm = Validator.ValidationAlgorythm.fazenda { (basicNumber: String) -> (Int) in
            return T.calcWeightSum(basicNumber: basicNumber)
        }

        return validator.isValid(validationAlgorythm: algorythm,
                                 allSameDigitsAreValid: allSameDigitsAreValid)
    }

    public static func generate() -> CNPJ {

        let cnpj = CNPJ.generate { (string: String) -> (Int) in
            return CNPJ.calcWeightSum(basicNumber: string)
        }
        return cnpj
    }
}

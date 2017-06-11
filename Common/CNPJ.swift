import Foundation

public struct CNPJ: FazendinhaNumberProtocol, Generatable, NumberParsedInfoInterface {

    public typealias NumberParsedType = CNPJ
    public typealias FazendinhaNumberType = CNPJ

    public static let checkDigitsCount: Int = 2
    public static let numberLength: Int = 14
    static let weights: [Int] = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
    static let separators: [Character] = [".", ".", "/", "-"]
    static let steps: [Int] = [2, 3, 3, 4, checkDigitsCount]
    let validator: Validator
    let parser: Parser = Parser()
    let numberParsedInfo: Parser.Info

    /**
     Creates a CNPJ from a given number
     - Parameter number: CNPJ number
     - Throws: `InputError.invalidFormat` if the string is not either just 14 numbers (E.g.: XXXXXXXXXXXXXX) or number with
     the CPF mask. (E.g.: XX.XXX.XXX/XXXX-XX)
     - Returns: CNPJ
     */
    public init(number: String) throws {

        let input = Parser.Input(number: number, separators: CNPJ.separators, steps: CNPJ.steps)
        self.numberParsedInfo = try parser.parse(input: input)

        self.validator = Validator(numberParsedInfo: numberParsedInfo)
    }

    public var isHeadquarters: Bool {
        return branchNumber == "0001"
    }

    public var branchNumber: String {
        return numberParsedInfo.parts.dropLast().last! // swiftlint:disable:this force_unwrapping
    }

    public func isValid(allSameDigitsAreValid: Bool = false) -> Bool {

        let algorythm = Validator.ValidationAlgorythm.fazenda { (basicNumber: String) -> (Int) in
            NumberParsedType.calcWeightSum(basicNumber: basicNumber)
        }

        return validator.isValid(validationAlgorythm: algorythm,
                                 allSameDigitsAreValid: allSameDigitsAreValid)
    }

    public static func generate() -> CNPJ {

        let cnpj = CNPJ.generate { (string: String) -> (Int) in
            CNPJ.calcWeightSum(basicNumber: string)
        }
        return cnpj
    }
}

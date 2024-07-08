/// A struct representing a CNPJ (Cadastro Nacional da Pessoa Jurídica), a Brazilian business registry identification number.
public struct CNPJ: NadaADeclararNumberProtocol, Generatable, NumberParsedInfoInterface {
    public typealias NumberParsedType = CNPJ
    public typealias NadaADeclararNumberType = CNPJ

    /// The number of check digits in the CNPJ.
    public static let checkDigitsCount: Int = 2

    /// The total length of the CNPJ number.
    public static let numberLength: Int = 14

    /// The weights used for calculating the check digits.
    static let weights: [Int] = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]

    /// The separators used in the CNPJ format.
    static let separators: [Character] = [".", ".", "/", "-"]

    /// The steps representing the parts of the CNPJ number.
    static let steps: [Int] = [2, 3, 3, 4, checkDigitsCount]

    /// The validator used for validating the CNPJ.
    let validator: Validator

    /// The parser used for parsing the CNPJ number.
    let parser: Parser = Parser()

    /// The parsed information of the CNPJ number.
    let numberParsedInfo: Parser.Info

    /**
     Initializes a new instance of `CNPJ` with a given number.

     - Parameter number: A string representing the CNPJ number. The string can either be a plain 14-digit number (e.g., "XXXXXXXXXXXXXX") or a number with the CNPJ mask (e.g., "XX.XXX.XXX/XXXX-XX").
     - Throws: `Parser.InputError.invalidFormat` if the provided string does not conform to the expected CNPJ format.
     - Returns: An initialized `CNPJ` object.
     */
    public init(number: String) throws {
        let input = Parser.Input(number: number, separators: CNPJ.separators, steps: CNPJ.steps)
        self.numberParsedInfo = try parser.parse(input: input)
        self.validator = Validator(numberParsedInfo: numberParsedInfo)
    }

    /**
     Indicates whether the CNPJ represents a headquarters.

     - Returns: `true` if the CNPJ represents a headquarters; otherwise, `false`.
     */
    public var isHeadquarters: Bool {
        return branchNumber == "0001"
    }

    /**
     Retrieves the branch number from the CNPJ.

     - Returns: A string representing the branch number.
     */
    public var branchNumber: String {
        return numberParsedInfo.parts.dropLast().last! // swiftlint:disable:this force_unwrapping
    }

    /**
     Indicates whether the CNPJ is valid.

     - Returns: `true` if the CNPJ is valid, `false` otherwise.
     */
    public var isValid: Bool {
        isValid(allSameDigitsAreValid: false)
    }

    /**
     Validates the CNPJ using the specified algorithm.

     - Parameter allSameDigitsAreValid: A flag indicating whether a CNPJ with all same digits is considered valid. Defaults to `false`.
     - Returns: `true` if the CNPJ is valid; otherwise, `false`.
     */
    func isValid(allSameDigitsAreValid: Bool = false) -> Bool {
        let algorithm = Validator.ValidationAlgorythm.fazenda { (basicNumber: String) -> (Int) in
            NumberParsedType.calcWeightSum(basicNumber: basicNumber)
        }
        return validator.isValid(validationAlgorythm: algorithm, allSameDigitsAreValid: allSameDigitsAreValid)
    }

    /**
     Generates a new CNPJ.

     - Returns: A new `CNPJ` object.
     */
    public static func generate() -> CNPJ {
        let cnpj = CNPJ.generate { (string: String) -> (Int) in
            CNPJ.calcWeightSum(basicNumber: string)
        }
        return cnpj
    }
}

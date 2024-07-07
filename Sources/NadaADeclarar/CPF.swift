/// A struct representing a CPF (Cadastro de Pessoas Físicas), a Brazilian individual taxpayer registry identification.
public struct CPF: NadaADeclararNumberProtocol, Generatable, NumberParsedInfoInterface {
    public typealias NumberParsedType = CPF
    public typealias NadaADeclararNumberType = CPF

    /// The number of check digits in the CPF.
    public static var checkDigitsCount: Int = 2

    /// The total length of the CPF number.
    public static var numberLength: Int = 11

    /// The weights used for calculating the check digits.
    static let weights: [Int] = [11, 10, 9, 8, 7, 6, 5, 4, 3, 2]

    /// The separators used in the CPF format.
    static let separators: [Character] = [".", ".", "-"]

    /// The steps representing the parts of the CPF number.
    static let steps: [Int] = [3, 3, 3, checkDigitsCount]

    /// The validator used for validating the CPF.
    let validator: Validator

    /// The parser used for parsing the CPF number.
    let parser: Parser = Parser()

    /// The parsed information of the CPF number.
    let numberParsedInfo: Parser.Info

    /**
     Initializes a new instance of `CPF` with a given number.

     - Parameter number: A string representing the CPF number. The string can either be a plain 11-digit number (e.g., "XXXXXXXXXXX") or a number with the CPF mask (e.g., "XXX.XXX.XXX-XX").
     - Throws: `Parser.InputError.invalidFormat` if the provided string does not conform to the expected CPF format.
     - Returns: An initialized `CPF` object.
     */
    public init(number: String) throws {
        let input = Parser.Input(number: number, separators: CPF.separators, steps: CPF.steps)
        self.numberParsedInfo = try parser.parse(input: input)
        self.validator = Validator(numberParsedInfo: numberParsedInfo)
    }

    /**
     Returns a set of states that belong to the fiscal region of the CPF.

     - Returns: A set of `State` objects.
     */
    public var states: Set<State> {
        let filtered = Brazil.states.filter { (state: State) -> Bool in
            state.fiscalRegion == fiscalRegion
        }
        return Set(filtered.map({ $0 }))
    }

    /**
     Returns the fiscal region of the CPF.

     - Returns: `FiscalRegion`
     */
    public var fiscalRegion: FiscalRegion {
        let frRange = Range(uncheckedBounds: (plainNumber.index(plainNumber.endIndex, offsetBy: -3),
                                              plainNumber.index(plainNumber.endIndex, offsetBy: -2)))
        // swiftlint:disable force_unwrapping
        let fiscalRegionString = plainNumber[frRange]
        let fiscalRegionValue = Int(fiscalRegionString)!
        let fiscalRegion = FiscalRegion(rawValue: fiscalRegionValue)!
        // swiftlint:enable force_unwrapping
        return fiscalRegion
    }

    /**
     Generates a new CPF.

     - Returns: A new `CPF`.
     */
    public static func generate() -> CPF {
        let cpf = CPF.generate { (string: String) -> (Int) in
            CPF.calcWeightSum(basicNumber: string)
        }
        return cpf
    }

    /**
     Validates the CPF.

     - Parameters:
     - validationAlgorythm: The algorithm to use for validation. Defaults to `.simple`.
     - allSameDigitsAreValid: A flag indicating whether a CPF with all same digits is valid. Defaults to `false`.
     - Returns: `true` if the CPF is valid, `false` otherwise.
     */
    public func isValid(validationAlgorythm: Validator.ValidationAlgorythm = .simple,
                        allSameDigitsAreValid: Bool = false) -> Bool {
        return validator.isValid(validationAlgorythm: validationAlgorythm,
                                 allSameDigitsAreValid: allSameDigitsAreValid)
    }

    public static let fazendaAlgorythm: Validator.ValidationAlgorythm =
    Validator.ValidationAlgorythm.fazenda { (basicNumber: String) -> (Int) in
        NumberParsedType.calcWeightSum(basicNumber: basicNumber)
    }
}

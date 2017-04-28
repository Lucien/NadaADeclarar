import Foundation

public struct CPF: FazendinhaNumberProtocol {
    typealias T = CPF

    public let plainNumber: String
    public let maskedNumber: String
    public let checkDigits: [Int]
    public static var checkDigitsCount: Int = 2
    public static var numberLength: Int = 11

    /**
     Creates a CPF from a given number
     - Parameter number: CPF number
     - Throws: `InputError.invalidFormat` if the string is not either just numbers (E.g.: XXXXXXXXXXX) or number with
     the CPF mask. (E.g.: XXX.XXX.XXX-XX)
     - Returns: CPF

     */
    public init(number: String) throws {

        let inputValidation = try CPF.validateNumberInput(number: number,
                                                          separators: [".", ".", "-"],
                                                          steps: [3, 3, 3, 2])
        self.plainNumber = inputValidation.plainNumber
        self.maskedNumber = inputValidation.maskedNumber
        self.checkDigits = inputValidation.checkDigits
    }

    public var states: [State] {
        
        return 🇧🇷.states.filter { (state: State) -> Bool in
            return state.fiscalRegion == fiscalRegion
        }
    }

    public func isValid(validationAlgorythm: ValidationAlgorythm, allSameDigitsAreValid: Bool) -> Bool {

    }

//    public static func generate() -> CPF {
//        return generate(basicNumberLength: 11, checkDigitsLength: 2)
//    }
}

extension CPF: PrivateFazendinhaNumberProtocol {

    func calculateWeightsSum(basicNumber: String) -> Int {
        return CPF.calcWeightSum(basicNumber: basicNumber)
    }

    static func calcWeightSum(basicNumber: String) -> Int {

        var sum = 0
        let range = Range(uncheckedBounds: (basicNumber.startIndex, upper: basicNumber.endIndex))

        let initialWeight = basicNumber.characters.count + 1

        basicNumber.enumerateSubstrings(in: range,
                                        options: [.byComposedCharacterSequences]) {
                                            (enumeratedString: String?,
                                            substringRange: Range<String.Index>,
                                            enclosingRange: Range<String.Index>,
                                            stop: inout Bool) in

                                            let info = getNumberAndIndex(fromEnumeratedString: enumeratedString,
                                                                         substringRange: substringRange,
                                                                         basicNumber: basicNumber)

                                            let weight = (initialWeight - info.index)
                                            sum += info.number * weight
        }

        return sum
    }

    public var fiscalRegion: FiscalRegion {

        let frRange = Range(uncheckedBounds: (plainNumber.index(plainNumber.endIndex, offsetBy: -3),
                                              plainNumber.index(plainNumber.endIndex, offsetBy: -2)))
        let fiscalRegion = FiscalRegion(rawValue: Int(plainNumber.substring(with: frRange))!)!
        return fiscalRegion
    }
}

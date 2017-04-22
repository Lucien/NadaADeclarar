import Foundation

public struct CPF: FazendinhaNumberProtocol, PrivateFazendinhaNumberProtocol {
    typealias T = CPF

    let plainNumber: String
    let maskedNumber: String
    let checkDigits: [Int]
    static let checkDigitsCount = 2
    static let numberLength = 11
    let number: String

    /**
     Creates a CPF from a given number
     - Parameter number: CPF number
     - Throws: `InputError.invalidFormat` if the string is not either just numbers (E.g.: XXXXXXXXXXX) or number with
     the CPF mask. (E.g.: XXX.XXX.XXX-XX)
     - Returns: CPF

     */
    public init(number: String) throws {

        self.number = number
        let inputValidation = try CPF.validateNumberInput(number: number,
                                                          separators: [".", ".", "-"],
                                                          steps: [3, 3, 3, 2])
        self.plainNumber = inputValidation.plainNumber
        self.maskedNumber = inputValidation.maskedNumber
        self.checkDigits = inputValidation.checkDigits
    }

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

    public var states: [State] {

        return 🇧🇷.states.filter { (state: State) -> Bool in
            return state.fiscalRegion == fiscalRegion
        }
    }
}

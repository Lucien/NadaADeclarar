import Foundation

public struct CNPJ: PrivateFazendinhaNumberProtocol {
    typealias T = CNPJ

    public let number: String
    public let plainNumber: String
    public let maskedNumber: String
    public let checkDigits: [Int]
    static let checkDigitsCount = 2
    static let numberLength = 14
    public let isHeadquarters: Bool

    public init(number: String) throws {

        self.number = number
        let inputValidation = try CNPJ.validateNumberInput(number: number,
                                                           separators: [".", ".", "/", "-"],
                                                           steps: [2, 3, 3, 4, 2])
        self.plainNumber = inputValidation.plainNumber
        self.maskedNumber = inputValidation.maskedNumber
        self.checkDigits = inputValidation.checkDigits

        let partsCount = inputValidation.parts.count
        if partsCount > 1 {
            let companyNumber = inputValidation.parts[partsCount - 2]
            self.isHeadquarters = companyNumber == "0001"
        } else {
            self.isHeadquarters = false
        }
    }

    func calculateWeightsSum(basicNumber: String) -> Int {
        return CNPJ.calcWeightSum(basicNumber: basicNumber)
    }

    public func isValid(allSameDigitsAreValid: Bool) -> Bool {
        return isValid(validationAlgorythm: .fazenda, allSameDigitsAreValid: allSameDigitsAreValid)
    }

    static func calcWeightSum(basicNumber: String) -> Int {
        var sum = 0
        let range = Range(uncheckedBounds: (basicNumber.startIndex, upper: basicNumber.endIndex))

        let weights = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
        let subWeights = Array(weights.dropFirst(weights.count - basicNumber.characters.count))

        basicNumber.enumerateSubstrings(in: range,
                                        options: [.byComposedCharacterSequences, .reverse]) {
                                            (enumeratedString: String?,
                                            substringRange: Range<String.Index>,
                                            enclosingRange: Range<String.Index>,
                                            stop: inout Bool) in

                                            let info = getNumberAndIndex(fromEnumeratedString: enumeratedString,
                                                                         substringRange: substringRange,
                                                                         basicNumber: basicNumber)

                                            let weight = subWeights[info.index]
                                            sum += info.number * weight
        }
        
        return sum
    }
}

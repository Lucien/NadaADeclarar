import Foundation

public struct CNPJ: FazendinhaNumberProtocol {

    static let checkDigitsCount = 2
    static let numberLength = 14
    public let plainNumber: String
    public let maskedNumber: String
    public let checkDigits: [Int]
    public let number: String

    public init(number: String) throws {

        self.number = number
        let inputValidation = try CNPJ.validateNumberInput(number: number,
                                                           separators: [".", ".", "/", "-"],
                                                           steps: [2, 3, 3, 4, 2])
        self.plainNumber = inputValidation.plainNumber
        self.maskedNumber = inputValidation.maskedNumber
        self.checkDigits = inputValidation.checkDigits
    }

}

public extension CNPJ {

    func calculateWeightsSum(basicNumber: String) -> Int {

        var sum = 0
        let range = Range(uncheckedBounds: (basicNumber.startIndex, upper: basicNumber.endIndex))

        let weights = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]

        basicNumber.enumerateSubstrings(in: range,
                                        options: [.byComposedCharacterSequences, .reverse]) {
                                            (enumeratedString: String?,
                                            substringRange: Range<String.Index>,
                                            enclosingRange: Range<String.Index>,
                                            stop: inout Bool) in

                                            let info = self.getNumberAndIndex(fromEnumeratedString: enumeratedString,
                                                                         substringRange: substringRange,
                                                                         basicNumber: basicNumber)
                                            let weight = weights[info.index]
                                            sum += info.number * weight
        }

        return sum
    }
}

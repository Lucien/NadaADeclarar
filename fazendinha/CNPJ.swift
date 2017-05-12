import Foundation

public struct CNPJ: FazendinhaNumberProtocol {

    typealias T = CNPJ

    public let plainNumber: String
    public let maskedNumber: String
    public let checkDigits: [Int]
    public let isHeadquarters: Bool
    let validator: Validator
    let parser = Parser()
    public static let checkDigitsCount = 2
    public static let numberLength = 14

    public init(number: String) throws {

        let numberParsedInfo = try parser.parse(number: number,
                                                separators: [".", ".", "/", "-"],
                                                steps: [2, 3, 3, 4, 2])

        self.plainNumber = numberParsedInfo.plainNumber
        self.maskedNumber = numberParsedInfo.maskedNumber
        self.checkDigits = numberParsedInfo.checkDigits
        self.validator = Validator(numberParsedInfo: numberParsedInfo)

        let partsCount = numberParsedInfo.parts.count
        if partsCount > 1 {
            let companyNumber = numberParsedInfo.parts[partsCount - 2]
            self.isHeadquarters = companyNumber == "0001"
        } else {
            self.isHeadquarters = false
        }
    }

    public func isValid(allSameDigitsAreValid: Bool = false) -> Bool {

        let algorythm = Validator.ValidationAlgorythm.fazenda { (basicNumber: String) -> (Int) in
            return T.calcWeightSum(basicNumber: basicNumber)
        }

        return validator.isValid(validationAlgorythm: algorythm,
                                 allSameDigitsAreValid: allSameDigitsAreValid)
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

    //    public static func generate() -> CNPJ {
    //        return generate(basicNumberLength: 12, checkDigitsLength: 2)
    //    }
}


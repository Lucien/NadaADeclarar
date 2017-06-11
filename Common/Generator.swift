import Foundation

protocol Generatable {
    associatedtype NumberParsedType: NumberParsedInfoInterface
    associatedtype FazendinhaNumberType: FazendinhaNumberProtocol
    static func generate() -> FazendinhaNumberType
    static var weights: [Int] { get }
}

extension Generatable {

    static func generate(weightsSumCalc: (String) -> (Int)) -> FazendinhaNumberType {

        let basicNumber = generateBasicNumber()

        let checkDigits = Validator.expectedCheckDigits(fromBasicNumber: basicNumber,
                                                        checkDigitsCount: NumberParsedType.checkDigitsCount,
                                                        calculateWeightsSum: weightsSumCalc)

        var number = basicNumber
        for checkDigit in checkDigits {
            number.append(String(checkDigit))
        }

        let fazendinhaType = try! FazendinhaNumberType(number: number) // swiftlint:disable:this force_try
        return fazendinhaType
    }

    static func generateBasicNumber() -> String {
        let basicNumberLength = NumberParsedType.numberLength - NumberParsedType.checkDigitsCount
        var randomNumber = ""
        for _ in 0 ..< basicNumberLength {
            randomNumber += String(arc4random() % 10)
        }
        return randomNumber
    }

    static func calcWeightSum(basicNumber: String) -> Int {

        var sum = 0
        let range = Range(uncheckedBounds: (basicNumber.startIndex, upper: basicNumber.endIndex))

        let subWeights = Array(weights.dropFirst(weights.count - basicNumber.count))

        basicNumber.enumerateSubstrings(in: range,
                                        options: [.byComposedCharacterSequences]) {
                                            (enumeratedString: String?,
                                            substringRange: Range<String.Index>,
                                            _: Range<String.Index>,
                                            _: inout Bool) in

                                            if let enumeratedString = enumeratedString {
                                                let info = getNumberAndIndex(fromEnumeratedString: enumeratedString,
                                                                             substringRange: substringRange,
                                                                             basicNumber: basicNumber)

                                                let weight = subWeights[info.index]
                                                sum += info.number * weight
                                            }
        }

        return sum
    }

    static func getNumberAndIndex(fromEnumeratedString enumeratedString: String,
                                  substringRange: Range<String.Index>,
                                  basicNumber: String) -> (number: Int, index: Int) {

        let number = Int(enumeratedString)! // swiftlint:disable:this force_unwrapping
        let index: Int = basicNumber.distance(from: basicNumber.startIndex,
                                              to: substringRange.lowerBound)
        return (number, index)
    }
}

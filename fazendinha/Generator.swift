import Foundation

protocol Generatable {
    associatedtype T: FazendinhaNumberProtocol
    static func generate() -> T
    static var weights: [Int] { get }
}

extension Generatable {

    static func generate(weightsSumCalc: (String) -> (Int)) -> T {

        let basicNumber = generateBasicNumber()

        let checkDigits = Validator.expectedCheckDigits(fromBasicNumber: basicNumber,
                                                        checkDigitsCount: T.checkDigitsCount,
                                                        calculateWeightsSum: weightsSumCalc)

        var number = basicNumber
        for checkDigit in checkDigits {
            number.append(String(checkDigit))
        }

        do {
            let fazendinhaType = try T(number: number)
            return fazendinhaType
        } catch {
            fatalError("Could not create CPF from number: \(number)")
        }
    }

    static func generateBasicNumber() -> String {
        let basicNumberLength = T.numberLength - T.checkDigitsCount
        var randomNumber = ""
        for _ in 0 ..< basicNumberLength {
            randomNumber += String(arc4random() % 10)
        }
        
        return randomNumber
    }

    static func calcWeightSum(basicNumber: String) -> Int {

        var sum = 0
        let range = Range(uncheckedBounds: (basicNumber.startIndex, upper: basicNumber.endIndex))

        let subWeights = Array(weights.dropFirst(weights.count - basicNumber.characters.count))

        basicNumber.enumerateSubstrings(in: range,
                                        options: [.byComposedCharacterSequences]) {
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

    static func getNumberAndIndex(fromEnumeratedString enumeratedString: String?,
                                  substringRange: Range<String.Index>,
                                  basicNumber: String) -> (number: Int, index: Int) {

        let number = Int(enumeratedString!)!
        let index: Int = basicNumber.distance(from: basicNumber.startIndex,
                                              to: substringRange.lowerBound)
        return (number, index)
    }
}

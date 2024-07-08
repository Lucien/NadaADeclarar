import Foundation

/// Protocol for generating numbers conforming to specific rules and formats.
protocol Generatable {
    associatedtype NumberParsedType: NumberParsedInfoInterface
    associatedtype NadaADeclararNumberType: NadaADeclararNumberProtocol

    /// Generates a new instance of `NadaADeclararNumberType`.
    ///
    /// - Returns: A newly generated `NadaADeclararNumberType`.
    static func generate() -> NadaADeclararNumberType

    /// Weights used in the calculation of check digits.
    static var weights: [Int] { get }
}

extension Generatable {

    /// Generates a new instance of `NadaADeclararNumberType` using a custom weight sum calculation.
    ///
    /// - Parameter weightsSumCalc: A closure that takes a string and returns the calculated sum of weights.
    /// - Returns: A newly generated `NadaADeclararNumberType`.
    static func generate(weightsSumCalc: (String) -> (Int)) -> NadaADeclararNumberType {
        let basicNumber = generateBasicNumber()
        let checkDigits = Validator.expectedCheckDigits(fromBasicNumber: basicNumber,
                                                        checkDigitsCount: NumberParsedType.checkDigitsCount,
                                                        calculateWeightsSum: weightsSumCalc)

        var number = basicNumber
        for checkDigit in checkDigits {
            number.append(String(checkDigit))
        }

        let nadaADeclararType = try! NadaADeclararNumberType(number: number) // swiftlint:disable:this force_try
        return nadaADeclararType
    }

    /// Generates the basic part of the number (without check digits).
    ///
    /// - Returns: A string representing the basic number.
    static func generateBasicNumber() -> String {
        let basicNumberLength = NumberParsedType.numberLength - NumberParsedType.checkDigitsCount
        var randomNumber = ""
        for _ in 0 ..< basicNumberLength {
            randomNumber += String(Int.random(in: 0...9))
        }
        return randomNumber
    }

    /// Calculates the sum of weights for the given basic number.
    ///
    /// - Parameter basicNumber: The basic number as a string.
    /// - Returns: The calculated sum of weights as an integer.
    static func calcWeightSum(basicNumber: String) -> Int {
        var sum = 0
        let range = Range(uncheckedBounds: (basicNumber.startIndex, basicNumber.endIndex))
        let subWeights = Array(weights.dropFirst(weights.count - basicNumber.count))

        basicNumber.enumerateSubstrings(in: range, options: [.byComposedCharacterSequences]) {
            (enumeratedString: String?, substringRange: Range<String.Index>, _, _) in

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

    /// Retrieves the number and its index from the given enumerated string.
    ///
    /// - Parameters:
    ///   - enumeratedString: The enumerated string.
    ///   - substringRange: The range of the substring in the basic number.
    ///   - basicNumber: The basic number as a string.
    /// - Returns: A tuple containing the number and its index.
    static func getNumberAndIndex(fromEnumeratedString enumeratedString: String,
                                  substringRange: Range<String.Index>,
                                  basicNumber: String) -> (number: Int, index: Int) {
        let number = Int(enumeratedString)! // swiftlint:disable:this force_unwrapping
        let index = basicNumber.distance(from: basicNumber.startIndex, to: substringRange.lowerBound)
        return (number, index)
    }
}

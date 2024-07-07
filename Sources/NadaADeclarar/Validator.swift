/// A struct responsible for validating parsed number information using different algorithms.
public struct Validator {

    /// The parsed information of the number to be validated.
    let numberParsedInfo: Parser.Info

    /**
     Validates the parsed number information using the specified validation algorithm.

     - Parameters:
       - validationAlgorythm: The algorithm to use for validation.
       - allSameDigitsAreValid: A flag indicating whether a number with all same digits is valid. Defaults to `false`.
     - Returns: `true` if the number is valid, `false` otherwise.
     */
    func isValid(validationAlgorythm: ValidationAlgorythm,
                 allSameDigitsAreValid: Bool = false) -> Bool {

        if !allSameDigitsAreValid {
            let charset = Set([Character](numberParsedInfo.plainNumber))
            if charset.count == 1 {
                return false
            }
        }

        switch validationAlgorythm {
        case .simple:
            return validateUsingSimpleAlgorythm(numberParsedInfo: numberParsedInfo)
        case .fazenda(let weightSumCalc):
            return validateUsingFazendaAlgorythm(numberParsedInfo: numberParsedInfo,
                                                 calculateWeightsSum: weightSumCalc)
        }
    }

    /**
     Validates the parsed number information using a simple algorithm.

     - Parameter numberParsedInfo: The parsed number information.
     - Returns: `true` if the number is valid according to the simple algorithm, `false` otherwise.
     */
    func validateUsingSimpleAlgorythm(numberParsedInfo: Parser.Info) -> Bool {

        let plainNumber = numberParsedInfo.plainNumber
        let checkDigitsCount = numberParsedInfo.checkDigits.count

        let upperBound = plainNumber.index(plainNumber.endIndex, offsetBy: -checkDigitsCount)
        let range = Range(uncheckedBounds: (plainNumber.startIndex, upper: upperBound))
        let basicNumberLength = plainNumber.count - checkDigitsCount

        var v1 = 0
        let moduloNumber = 11
        var v2 = 0
        var index = 0

        plainNumber.enumerateSubstrings(in: range,
                                        options: [.byComposedCharacterSequences, .reverse]) {
            (enumeratedString: String?,
             _: Range<String.Index>,
             _: Range<String.Index>,
             _: inout Bool) in

            if let enumeratedString = enumeratedString {
                let number = Int(enumeratedString)! // swiftlint:disable:this force_unwrapping
                v1 += number * (basicNumberLength - index)
                v2 += number * (basicNumberLength - (index + 1))
                index += 1
            }
        }

        v1 = v1 % moduloNumber % (moduloNumber - 1)
        v2 += v1 * basicNumberLength
        v2 = v2 % moduloNumber % (moduloNumber - 1)

        return numberParsedInfo.checkDigits == [v1, v2]
    }

    /**
     Validates the parsed number information using the Fazenda algorithm.

     - Parameters:
       - numberParsedInfo: The parsed number information.
       - calculateWeightsSum: A closure that calculates the sum of weights for a given string.
     - Returns: `true` if the number is valid according to the Fazenda algorithm, `false` otherwise.
     */
    func validateUsingFazendaAlgorythm(numberParsedInfo: Parser.Info,
                                       calculateWeightsSum: (String) -> Int) -> Bool {

        let plainNumber = numberParsedInfo.plainNumber
        let checkDigitsCount = numberParsedInfo.checkDigits.count

        let upperBound = plainNumber.index(plainNumber.endIndex, offsetBy: -checkDigitsCount)
        let basicNumber = String(plainNumber[..<upperBound])

        let expectedCheckDigits = Validator.expectedCheckDigits(fromBasicNumber: basicNumber,
                                                                checkDigitsCount: checkDigitsCount,
                                                                calculateWeightsSum: calculateWeightsSum)

        return numberParsedInfo.checkDigits == expectedCheckDigits
    }

    /**
     Calculates the expected check digits from the basic number using the given weight sum calculation.

     - Parameters:
       - basicNumber: The basic number as a string.
       - checkDigitsCount: The number of check digits.
       - calculateWeightsSum: A closure that calculates the sum of weights for a given string.
     - Returns: An array of integers representing the expected check digits.
     */
    static func expectedCheckDigits(fromBasicNumber basicNumber: String,
                                    checkDigitsCount: Int,
                                    calculateWeightsSum: (String) -> (Int)) -> [Int] {

        let moduloNumber = 11
        var expectedCheckDigits = [Int]()
        var nextBasicNumber = basicNumber

        for i in 0..<checkDigitsCount {
            let sum = calculateWeightsSum(nextBasicNumber)
            let remainder = sum % moduloNumber
            let v = (remainder < 2) ? 0 : moduloNumber - remainder
            assert(v >= 0 && v < 10, "verification number out of range 0 <= v <= 9")
            nextBasicNumber.append(String(v))
            expectedCheckDigits.insert(v, at: i)
        }
        return expectedCheckDigits
    }

    /// An enum representing the validation algorithms.
    public enum ValidationAlgorythm {
        /// Simple validation algorithm.
        case simple

        /// Fazenda validation algorithm with a weight sum calculation closure.
        case fazenda(weightSumCalculation: (String) -> (Int))
    }
}

import Foundation

public struct Validator {

    public let numberParsedInfo: Parser.Info

    public func isValid(validationAlgorythm: ValidationAlgorythm,
                        allSameDigitsAreValid: Bool = false) -> Bool {

        if !allSameDigitsAreValid {

            let charset = Set([Character](numberParsedInfo.plainNumber.characters))
            if charset.count == 1 {
                return false
            }
        }

        switch validationAlgorythm {
        case .simple:
            return validateUsingSimpleAlgorythm(numberParsedInfo: numberParsedInfo)
        case .fazenda (let weightSumCalc):
            return validateUsingFazendaAlgorythm(numberParsedInfo: numberParsedInfo,
                                                 calculateWeightsSum: weightSumCalc)
        }
    }

    func validateUsingSimpleAlgorythm(numberParsedInfo: Parser.Info) -> Bool {

        let plainNumber = numberParsedInfo.plainNumber
        let checkDigitsCount = numberParsedInfo.checkDigits.count

        let upperBound = plainNumber.index(plainNumber.endIndex, offsetBy: -checkDigitsCount)
        let range = Range(uncheckedBounds: (plainNumber.startIndex, upper: upperBound))
        let basicNumberLength = plainNumber.characters.count - checkDigitsCount

        var v1 = 0
        let moduloNumber = 11
        var v2 = 0
        var index = 0

        plainNumber.enumerateSubstrings(in: range,
                                        options: [.byComposedCharacterSequences, .reverse]) {
                                            (enumeratedString: String?,
                                            substringRange: Range<String.Index>,
                                            enclosingRange: Range<String.Index>,
                                            stop: inout Bool) in

                                            let number = Int(enumeratedString!)!
                                            v1 += number * (basicNumberLength - index)
                                            v2 += number * (basicNumberLength - (index + 1))
                                            index += 1
        }

        v1 = v1 % moduloNumber % (moduloNumber-1)
        v2 += v1 * basicNumberLength
        v2 = v2 % moduloNumber % (moduloNumber-1)

        return numberParsedInfo.checkDigits == [v1, v2]
    }

    func validateUsingFazendaAlgorythm(numberParsedInfo: Parser.Info,
                                       calculateWeightsSum: (String) -> Int) -> Bool {

        let plainNumber = numberParsedInfo.plainNumber
        let checkDigitsCount = numberParsedInfo.checkDigits.count

        let upperBound = plainNumber.index(plainNumber.endIndex, offsetBy: -checkDigitsCount)

        let basicNumber = plainNumber.substring(to: upperBound)

        let expectedCheckDigits = Validator.expectedCheckDigits(fromBasicNumber: basicNumber,
                                                                checkDigitsCount: checkDigitsCount,
                                                                calculateWeightsSum: calculateWeightsSum)
        
        return numberParsedInfo.checkDigits == expectedCheckDigits
    }

    static func expectedCheckDigits(fromBasicNumber basicNumber: String,
                                    checkDigitsCount: Int,
                                    calculateWeightsSum: (String) -> (Int)) -> [Int] {

        let moduloNumber = 11
        var expectedCheckDigits = [Int]()
        var nextBasicNumber = basicNumber

        for i in 0..<checkDigitsCount {

            let sum = calculateWeightsSum(nextBasicNumber)
            let remainder = sum % moduloNumber
            let v = (remainder == 1 || remainder == 0) ? 0 : moduloNumber - remainder
            nextBasicNumber.append(String(v))
            expectedCheckDigits.insert(v, at: i)
        }
        return expectedCheckDigits
    }


    public enum ValidationAlgorythm {
        case simple
        case fazenda(weightSumCalculation: (String) -> (Int))
    }
}

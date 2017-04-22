import Foundation

public enum InputError: Error {
    case invalidFormat
}

public enum ValidationAlgorythm {
    case simple
    case fazenda
}

protocol FazendinhaNumberProtocol {

    static var numberLength: Int { get }
    static var checkDigitsCount: Int { get }
    var checkDigits: [Int] { get }
    var number: String { get }
    var plainNumber: String { get }
    var maskedNumber: String { get }

    init(number: String) throws

    func isValid(validationAlgorythm: ValidationAlgorythm, allSameDigitsAreValid: Bool) -> Bool

    static func validateNumberInput(number: String,
                                    separators: [Character],
                                    steps: [Int]) throws ->
        (plainNumber: String, maskedNumber: String, checkDigits: [Int])

    static func partsOfNumber(number: String, characterSetToSkip: CharacterSet) -> [String]

    func calculateWeightsSum(basicNumber: String) -> Int
    func getNumberAndIndex(fromEnumeratedString enumeratedString: String?,
                           substringRange: Range<String.Index>,
                           basicNumber: String) -> (number: Int, index: Int)


    func validateUsingSimpleAlgorythm() -> Bool
    func validateUsingFazendaAlgorythm() -> Bool

}

extension FazendinhaNumberProtocol {

    public func isValid(validationAlgorythm: ValidationAlgorythm = .fazenda,
                        allSameDigitsAreValid: Bool = false) -> Bool {

        if !allSameDigitsAreValid {
            let charset = Set([Character](plainNumber.characters))
            if charset.count == 1 {
                return false
            }
        }

        switch validationAlgorythm {
        case .simple:
            return validateUsingSimpleAlgorythm()
        case .fazenda:
            return validateUsingFazendaAlgorythm()
        }
    }

    static func validateNumberInput(number: String,
                                    separators: [Character],
                                    steps: [Int]) throws ->
        (plainNumber: String, maskedNumber: String, checkDigits: [Int]) {

            var plainNumber: String = number
            var maskedNumber: String = number
            let decimalDigitsCharSet = CharacterSet.decimalDigits

            func validatePlainChars() throws {

                let parts = partsOfNumber(number: number, characterSetToSkip: decimalDigitsCharSet.inverted)

                guard var part = parts.first,
                    part.characters.count == CPF.numberLength,
                    part == number else {
                        throw InputError.invalidFormat
                }

                var offset = 0
                for i in 0..<separators.count {
                    offset += steps[i] + (i == 0 ? 0 : 1)
                    let separator = separators[i]
                    part.insert(separator, at: part.index(part.startIndex, offsetBy: offset))
                }

                maskedNumber = part
            }

            func validateMaskedChars() throws {

                func validateNumbers() throws {

                    let parts = partsOfNumber(number: number, characterSetToSkip: decimalDigitsCharSet.inverted)
                    var counter = 0
                    var completeString = ""
                    for part in parts {
                        if part.characters.count != steps[counter] {
                            throw InputError.invalidFormat
                        }
                        completeString += part
                        counter += 1
                    }
                    plainNumber = completeString
                }

                func validateSeparators() throws {

                    let parts = partsOfNumber(number: number, characterSetToSkip: decimalDigitsCharSet)
                    var counter = 0
                    for part in parts {

                        if part.characters.first != separators[counter] {
                            throw InputError.invalidFormat
                        }
                        counter += 1
                    }
                }

                try validateNumbers()
                try validateSeparators()
            }

            let charCount = number.characters.count
            if charCount == numberLength {
                try validatePlainChars()
            } else if charCount == numberLength + separators.count {
                try validateMaskedChars()
            } else {
                throw InputError.invalidFormat
            }

            // check digits
            let checkDigitsString = plainNumber.substring(from: plainNumber.index(plainNumber.endIndex,
                                                                                  offsetBy: -checkDigitsCount))
            var checkDigits = [Int]()
            for char in checkDigitsString.characters {
                checkDigits.append(Int(String(char))!)
            }

            return (plainNumber, maskedNumber, checkDigits)
    }

    static func partsOfNumber(number: String, characterSetToSkip: CharacterSet) -> [String] {

        let scanner = Scanner(string: number)
        scanner.charactersToBeSkipped = characterSetToSkip
        var parts: [String] = []
        var part: NSString?
        while scanner.scanUpToCharacters(from: characterSetToSkip,
                                         into: &part) {

                                            if let part = part {
                                                parts.append(part as String)
                                            }
        }
        return parts
    }

    public func validateUsingSimpleAlgorythm() -> Bool {

        let upperBound = plainNumber.index(plainNumber.endIndex, offsetBy: -2)
        let range = Range(uncheckedBounds: (plainNumber.startIndex, upper: upperBound))

        var v1 = 0
        var v2 = 0
        var index = 0

        plainNumber.enumerateSubstrings(in: range,
                                        options: [.byComposedCharacterSequences, .reverse]) {
                                            (enumeratedString: String?,
                                            substringRange: Range<String.Index>,
                                            enclosingRange: Range<String.Index>,
                                            stop: inout Bool) in

                                            let number = Int(enumeratedString!)!
                                            v1 += number * (9 - index)
                                            v2 += number * (9 - (index + 1))
                                            index += 1
        }

        v1 = v1 % plainNumber.characters.count % 10
        v2 += v1 * 9
        v2 = v2 % plainNumber.characters.count % 10
        
        return checkDigits == [v1, v2]
    }

    public func validateUsingFazendaAlgorythm() -> Bool {

        let checkDigits = self.checkDigits

        let checkDigitsCount = checkDigits.count

        let upperBound = plainNumber.index(plainNumber.endIndex, offsetBy: -checkDigitsCount)
        let basicNumber = plainNumber.substring(to: upperBound)


        var expectedCheckDigits = [Int]()
        var nextBasicNumber = basicNumber

        for i in 0..<checkDigitsCount {

            let sum = calculateWeightsSum(basicNumber: nextBasicNumber)
            let remainder = sum % plainNumber.characters.count
            let v = (remainder == 1 || remainder == 0) ? 0 : plainNumber.characters.count - remainder
            nextBasicNumber.append(String(v))
            expectedCheckDigits.insert(v, at: i)
        }

        return checkDigits == expectedCheckDigits
    }

    func getNumberAndIndex(fromEnumeratedString enumeratedString: String?,
                           substringRange: Range<String.Index>,
                           basicNumber: String) -> (number: Int, index: Int) {

        let number = Int(enumeratedString!)!
        let index: Int = basicNumber.distance(from: basicNumber.startIndex,
                                              to: substringRange.lowerBound)
        return (number, index)
    }
}

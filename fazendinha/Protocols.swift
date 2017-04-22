import Foundation

public enum InputError: Error {
    case invalidFormat
}

public enum ValidationAlgorythm {
    case simple
    case fazenda
}

public protocol FazendinhaNumberProtocol {
    init(number: String) throws
}

protocol PrivateFazendinhaNumberProtocol: FazendinhaNumberProtocol {

    static var numberLength: Int { get }
    static var checkDigitsCount: Int { get }
    var checkDigits: [Int] { get }
    var number: String { get }
    var plainNumber: String { get }
    var maskedNumber: String { get }

    func isValid(validationAlgorythm: ValidationAlgorythm, allSameDigitsAreValid: Bool) -> Bool
    static func generate() -> Self

    func calculateWeightsSum(basicNumber: String) -> Int
    static func calcWeightSum(basicNumber: String) -> Int
}

extension PrivateFazendinhaNumberProtocol {

    public static func generate() -> Self {

        let basicNumber = generateBasicNumber()
        let checkDigits = expectedCheckDigits(fromBasicNumber: basicNumber)

        var number = basicNumber
        for checkDigit in checkDigits {
            number.append(String(checkDigit))
        }

        do {
            let fazendinhaType = try Self(number: number)
            return fazendinhaType
        } catch {
            fatalError("Could not create CPF from number: \(number)")
        }
    }

    static func generateBasicNumber() -> String {
        let basicNumberLength = numberLength - checkDigitsCount
        var randomNumber = ""
        for _ in 0 ..< basicNumberLength {
            randomNumber += String(arc4random() % 10)
        }

        return randomNumber
    }

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
        (plainNumber: String, maskedNumber: String, checkDigits: [Int], parts: [String]) {

            var plainNumber: String = number
            var maskedNumber: String = number
            var parts = [String]()
            let decimalDigitsCharSet = CharacterSet.decimalDigits

            func validatePlainChars() throws {

                let plainParts = partsOfNumber(number: number, characterSetToSkip: decimalDigitsCharSet.inverted)

                guard var number = plainParts.first,
                    number.characters.count == numberLength,
                    number == number else {
                        throw InputError.invalidFormat
                }

                var offset = 0
                for i in 0..<separators.count {

                    offset += steps[i] + (i == 0 ? 0 : 1)
                    let separator = separators[i]

                    let location = number.index(number.startIndex, offsetBy: offset)
                    number.insert(separator, at: location)
                }

                maskedNumber = number
                parts = partsOfNumber(number: maskedNumber, characterSetToSkip: decimalDigitsCharSet)
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

            return (plainNumber, maskedNumber, checkDigits, parts)
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


        let upperBound = plainNumber.index(plainNumber.endIndex, offsetBy: -Self.checkDigitsCount)
        let range = Range(uncheckedBounds: (plainNumber.startIndex, upper: upperBound))
        let basicNumberLength = plainNumber.characters.count - Self.checkDigitsCount

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

        return checkDigits == [v1, v2]
    }

    public func validateUsingFazendaAlgorythm() -> Bool {

        let checkDigitsCount = checkDigits.count

        let upperBound = plainNumber.index(plainNumber.endIndex, offsetBy: -checkDigitsCount)

        let basicNumber = plainNumber.substring(to: upperBound)
        let moduloNumber = 11

        var expectedCheckDigits = [Int]()
        var nextBasicNumber = basicNumber

        for i in 0..<checkDigitsCount {

            let sum = calculateWeightsSum(basicNumber: nextBasicNumber)
            let remainder = sum % moduloNumber
            let v = (remainder == 1 || remainder == 0) ? 0 : moduloNumber - remainder
            nextBasicNumber.append(String(v))
            expectedCheckDigits.insert(v, at: i)
        }

        return checkDigits == expectedCheckDigits
    }

    static func expectedCheckDigits(fromBasicNumber basicNumber: String) -> [Int] {

        let moduloNumber = 11
        var expectedCheckDigits = [Int]()
        var nextBasicNumber = basicNumber

        for i in 0..<checkDigitsCount {

            let sum = calcWeightSum(basicNumber: nextBasicNumber)
            let remainder = sum % moduloNumber
            let v = (remainder == 1 || remainder == 0) ? 0 : moduloNumber - remainder
            nextBasicNumber.append(String(v))
            expectedCheckDigits.insert(v, at: i)
        }
        return expectedCheckDigits
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

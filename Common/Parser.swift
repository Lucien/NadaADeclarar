import Foundation

struct Parser {

    struct Info {
        let plainNumber: String
        let maskedNumber: String
        let checkDigits: [Int]
        let parts: [String]
    }

    struct Input {
        let number: String
        let separators: [Character]
        let steps: [Int]
    }

    func parse(input: Input) throws -> Info {

        let steps = input.steps
        let number = input.number
        let separators = input.separators
        let numberLength = steps.reduce(0, +)
        let checkDigitsCount = steps.last! // swiftlint:disable:this force_unwrapping

        var plainNumber: String = number
        var maskedNumber: String = number
        var parts = [String]()

        let charCount = number.count
        if charCount == numberLength {
            try validatePlainChars(input: input, parts: &parts, maskedNumber: &maskedNumber)
        } else if charCount == numberLength + separators.count {
            try validateMaskedChars(input: input, parts: &parts, plainNumber: &plainNumber)
        } else {
            throw InputError.invalidFormat
        }

        // check digits
        let checkDigitsString = plainNumber.substring(from: plainNumber.index(plainNumber.endIndex,
                                                                              offsetBy: -checkDigitsCount))
        var checkDigits = [Int]()
        for char in checkDigitsString.characters {
            let checkDigit = Int(String(char))! // swiftlint:disable:this force_unwrapping
            checkDigits.append(checkDigit)
        }

        return Info(plainNumber: plainNumber,
                    maskedNumber: maskedNumber,
                    checkDigits: checkDigits,
                    parts: parts)
    }

    func validateMaskedChars(input: Input,
                             parts: inout [String],
                             plainNumber: inout String) throws {

        let number = input.number
        let decimalDigitsCharSet = CharacterSet.decimalDigits

        func validateNumbers() throws {

            parts = partsOfNumber(number: number, characterSetToSkip: decimalDigitsCharSet.inverted)

            var counter = 0
            var completeString = ""
            for part in parts {
                if part.count != input.steps[counter] {
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

                if part.characters.first != input.separators[counter] {
                    throw InputError.invalidFormat
                }
                counter += 1
            }
        }

        try validateNumbers()
        try validateSeparators()
    }

    func validatePlainChars(input: Input,
                            parts: inout [String],
                            maskedNumber: inout String) throws {

        let steps = input.steps
        let separators = input.separators
        let numberLength = steps.reduce(0, +)
        let decimalDigitsCharSet = CharacterSet.decimalDigits

        let plainParts = partsOfNumber(number: input.number, characterSetToSkip: decimalDigitsCharSet.inverted)

        guard var number: String = plainParts.first,
            number.count == numberLength,
            number == input.number else {
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

    func partsOfNumber(number: String, characterSetToSkip: CharacterSet) -> [String] {

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

    public enum InputError: Error {
        case invalidFormat
    }
}

extension Parser.Info: Hashable {
    var hashValue: Int {

        let checkDigitsHashValue = checkDigits.reduce(5_381) {
            return ($0 << 5) &+ $0 &+ Int($1)
        }.hashValue

        return (plainNumber.hashValue ^
            maskedNumber.hashValue ^
            checkDigitsHashValue)
    }

    static func == (lhs: Parser.Info, rhs: Parser.Info) -> Bool {
        return (lhs.plainNumber == rhs.plainNumber &&
            lhs.maskedNumber == rhs.maskedNumber &&
            lhs.checkDigits == rhs.checkDigits &&
            lhs.parts == rhs.parts)
    }
}

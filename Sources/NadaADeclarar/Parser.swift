import Foundation

/// A structure that handles parsing of formatted numbers and extracts useful information.
public struct Parser {

    /// A structure that holds the parsed information of a number.
    struct Info {
        /// The plain number without any separators.
        let plainNumber: String

        /// The masked number with separators included.
        let maskedNumber: String

        /// An array of integers representing the check digits of the number.
        let checkDigits: [Int]

        /// An array of strings representing different parts of the number.
        let parts: [String]
    }

    /// A structure that holds the input details required for parsing a number.
    struct Input {
        /// The number as a string to be parsed.
        let number: String

        /// An array of characters representing the separators used in the masked number.
        let separators: [Character]

        /// An array of integers representing the number of digits in each part of the number.
        let steps: [Int]
    }

    /// Parses the input number and returns the parsed information.
    ///
    /// - Parameter input: The input details required for parsing.
    /// - Throws: `Parser.InputError.invalidFormat` if the input number does not match the expected format.
    /// - Returns: The parsed information as a `Parser.Info` object.
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

        // Extract check digits
        let startIndex = plainNumber.index(plainNumber.endIndex, offsetBy: -checkDigitsCount)
        let checkDigitsSubstring = plainNumber[startIndex...]
        let checkDigitsString = String(checkDigitsSubstring)

        var checkDigits = [Int]()
        for char in checkDigitsString {
            let checkDigit = Int(String(char))! // swiftlint:disable:this force_unwrapping
            checkDigits.append(checkDigit)
        }

        return Info(plainNumber: plainNumber,
                    maskedNumber: maskedNumber,
                    checkDigits: checkDigits,
                    parts: parts)
    }

    /// Validates the characters of the masked number and extracts its parts.
    ///
    /// - Parameters:
    ///   - input: The input details required for parsing.
    ///   - parts: The array to store the parts of the number.
    ///   - plainNumber: The plain number without any separators.
    /// - Throws: `InputError.invalidFormat` if the input number does not match the expected format.
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
                if part.first != input.separators[counter] {
                    throw InputError.invalidFormat
                }
                counter += 1
            }
        }

        try validateNumbers()
        try validateSeparators()
    }

    /// Validates the characters of the plain number and constructs the masked number.
    ///
    /// - Parameters:
    ///   - input: The input details required for parsing.
    ///   - parts: The array to store the parts of the number.
    ///   - maskedNumber: The masked number with separators included.
    /// - Throws: `InputError.invalidFormat` if the input number does not match the expected format.
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

    /// Splits the number into parts based on the character set to be skipped.
    ///
    /// - Parameters:
    ///   - number: The number to be split into parts.
    ///   - characterSetToSkip: The character set to be skipped while splitting.
    /// - Returns: An array of strings representing the parts of the number.
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

    /// Enum representing the possible errors that can occur during input validation.
    public enum InputError: Error {
        case invalidFormat
    }
}

extension Parser.Info: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(plainNumber)
        hasher.combine(maskedNumber)
        let checkDigitsHashValue = checkDigits.reduce(5_381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
        hasher.combine(checkDigitsHashValue)
    }

    static func == (lhs: Parser.Info, rhs: Parser.Info) -> Bool {
        lhs.plainNumber == rhs.plainNumber &&
        lhs.maskedNumber == rhs.maskedNumber &&
        lhs.checkDigits == rhs.checkDigits &&
        lhs.parts == rhs.parts
    }
}

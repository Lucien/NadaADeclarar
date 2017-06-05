import Foundation

struct Parser {

    struct Info {
        let plainNumber: String
        let maskedNumber: String
        let checkDigits: [Int]
        let parts: [String]
    }

    func parse(number: String,
               separators: [Character],
               steps: [Int]) throws -> Info {

        let numberLength = steps.reduce(0, +)
        let checkDigitsCount = steps.last!

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

                parts = partsOfNumber(number: number, characterSetToSkip: decimalDigitsCharSet.inverted)

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

        return Info(plainNumber: plainNumber,
                    maskedNumber: maskedNumber,
                    checkDigits: checkDigits,
                    parts: parts)
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

        let checkDigitsHashValue = checkDigits.reduce(5381) {
            return ($0 << 5) &+ $0 &+ Int($1)
            }.hashValue

        return (plainNumber.hashValue ^
            maskedNumber.hashValue ^
            checkDigitsHashValue)
    }
    
    static func ==(lhs: Parser.Info, rhs: Parser.Info) -> Bool {
        return (lhs.plainNumber == rhs.plainNumber &&
            lhs.maskedNumber == rhs.maskedNumber &&
            lhs.checkDigits == rhs.checkDigits &&
            lhs.parts == rhs.parts)
    }
}

import Foundation

public struct CNPJ {

    static let numberLength = 14

    public let plainNumber: String
    public let maskedNumber: String
    public let number: String

    public init(number: String) throws {

        self.number = number
        let inputValidation = try CPF.validateNumberInput(number: number)
        self.plainNumber = inputValidation.plainNumber
        self.maskedNumber = inputValidation.maskedNumber
    }

}

public extension CNPJ {

    static func validateNumberInput(number: String) throws -> (plainNumber: String, maskedNumber: String) {

        var plainNumber: String = number
        var maskedNumber: String = number
        let separators: [Character] = [".", ".", "-"]
        let steps = [3, 3, 3, 2]

        let decimalDigitsCharSet = CharacterSet.decimalDigits

        func validateElevenChars() throws {

            let parts = partsOfNumber(number: number, characterSetToSkip: decimalDigitsCharSet.inverted)

            guard var part = parts.first,
                part.characters.count == CPF.numberLength,
                part == number else {
                    throw InputError.invalidFormat
            }

            let separator1Offset = steps[0]
            let separator2Offset = separator1Offset + steps[1]
            let separator3Offset = separator2Offset + steps[2]

            part.insert(separators[2], at: part.index(part.startIndex, offsetBy: separator3Offset))
            part.insert(separators[1], at: part.index(part.startIndex, offsetBy: separator2Offset))
            part.insert(separators[0], at: part.index(part.startIndex, offsetBy: separator1Offset))
            maskedNumber = part
        }

        func validateFourteenChars() throws {

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
        if charCount == CPF.numberLength {
            try validateElevenChars()
        } else if charCount == CPF.numberLength + separators.count {
            try validateFourteenChars()
        } else {
            throw InputError.invalidFormat
        }

        return (plainNumber, maskedNumber)
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
}

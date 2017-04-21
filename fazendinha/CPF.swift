import Foundation

public struct CPF: FazendinhaNumberProtocol {

    static let numberLength = 11
    public let number: String
    public let plainNumber: String
    public let maskedNumber: String

    /**
     Creates a CPF from a given number
     - Parameter number: CPF number
     - Throws: `InputError.invalidFormat` if the string is not either just numbers (E.g.: XXXXXXXXXXX) or number with
     the CPF mask. (E.g.: XXX.XXX.XXX-XX)
     - Returns: CPF

     */
    public init(number: String) throws {

        self.number = number
        let inputValidation = try CPF.validateNumberInput(number: number)
        self.plainNumber = inputValidation.plainNumber
        self.maskedNumber = inputValidation.maskedNumber
    }

    public var fiscalRegion: FiscalRegion {

        let frRange = Range(uncheckedBounds: (plainNumber.index(plainNumber.endIndex, offsetBy: -3),
                                              plainNumber.index(plainNumber.endIndex, offsetBy: -2)))
        let fiscalRegion = FiscalRegion(rawValue: Int(plainNumber.substring(with: frRange))!)!
        return fiscalRegion
    }

    public var states: [State] {

        return 🇧🇷.states.filter { (state: State) -> Bool in
            return state.fiscalRegion == fiscalRegion
        }
    }

    public var checkDigits: (Int, Int) {

        // TODO: improve
        let v1Range = Range(uncheckedBounds: (plainNumber.index(plainNumber.endIndex, offsetBy: -2),
                                              plainNumber.index(plainNumber.endIndex, offsetBy: -1)))
        let v1Check = Int(plainNumber.substring(with: v1Range))!

        let v2Range = Range(uncheckedBounds: (plainNumber.index(plainNumber.endIndex, offsetBy: -1),
                                              plainNumber.index(plainNumber.endIndex, offsetBy: 0)))
        let v2Check = Int(plainNumber.substring(with: v2Range))!

        return (v1Check, v2Check)
    }

    public var isValid: Bool {

        // check for CPFs with all same algorisms (e.g. 000.000.000-00)
        let charset = Set([Character](plainNumber.characters))

        if charset.count == 1 {
            return false
        }

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

        v1 = (v1 % CPF.numberLength) % 10
        v2 += v1 * 9
        v2 = (v2 % CPF.numberLength) % 10

        let checkDigits = self.checkDigits
        return v1 == checkDigits.0 && v2 == checkDigits.1
    }

    func validationType2() {
        
    }
}

public extension CPF {

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

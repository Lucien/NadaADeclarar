import Foundation

public enum InputError: Error {
    case invalidFormat
}

protocol FazendinhaNumberProtocol {

    static var numberLength: Int { get }
    var number: String { get }
    var plainNumber: String { get }
    var maskedNumber: String { get }

    init(number: String) throws
    static func validateNumberInput(number: String) throws -> (plainNumber: String, maskedNumber: String)
    static func partsOfNumber(number: String, characterSetToSkip: CharacterSet) -> [String]
}

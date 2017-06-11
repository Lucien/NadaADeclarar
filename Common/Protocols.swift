import Foundation

public protocol FazendinhaNumberProtocol {

    init(number: String) throws

    var checkDigits: [Int] { get }
    var plainNumber: String { get }
    var maskedNumber: String { get }
}

protocol NumberParsedInfoInterface: Hashable {
    var numberParsedInfo: Parser.Info { get }
    static var checkDigitsCount: Int { get }
    static var numberLength: Int { get }
}

extension NumberParsedInfoInterface {
    public var plainNumber: String {
        return numberParsedInfo.plainNumber
    }

    public var maskedNumber: String {
        return numberParsedInfo.maskedNumber
    }

    public var checkDigits: [Int] {
        return numberParsedInfo.checkDigits
    }

    public var hashValue: Int {
        return numberParsedInfo.hashValue
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.numberParsedInfo == rhs.numberParsedInfo
    }
}

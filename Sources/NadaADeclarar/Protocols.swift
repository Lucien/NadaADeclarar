public protocol NadaADeclararNumberProtocol {
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
        numberParsedInfo.plainNumber
    }

    public var maskedNumber: String {
        numberParsedInfo.maskedNumber
    }

    public var checkDigits: [Int] {
        numberParsedInfo.checkDigits
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(numberParsedInfo)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.numberParsedInfo == rhs.numberParsedInfo
    }
}

import Foundation

public protocol FazendinhaNumberProtocol {

    init(number: String) throws

    var checkDigits: [Int] { get }
    var plainNumber: String { get }
    var maskedNumber: String { get }
    static var checkDigitsCount: Int { get }
    static var numberLength: Int { get }
}

protocol Calc {
    static func calcWeightSum(basicNumber: String) -> Int
}

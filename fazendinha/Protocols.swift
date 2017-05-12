import Foundation

public protocol FazendinhaNumberProtocol {

    init(number: String) throws

    var checkDigits: [Int] { get }
    var plainNumber: String { get }
    var maskedNumber: String { get }
    static var checkDigitsCount: Int { get }
    static var numberLength: Int { get }
}

extension FazendinhaNumberProtocol {

    static func getNumberAndIndex(fromEnumeratedString enumeratedString: String?,
                           substringRange: Range<String.Index>,
                           basicNumber: String) -> (number: Int, index: Int) {

        let number = Int(enumeratedString!)!
        let index: Int = basicNumber.distance(from: basicNumber.startIndex,
                                              to: substringRange.lowerBound)
        return (number, index)
    }
}

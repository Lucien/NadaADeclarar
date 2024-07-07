import XCTest
@testable import NadaADeclarar

class ParserTests: XCTestCase {

    func testEquatableParserInfo() {
        let parserInfo1 = Parser.Info(
            plainNumber: "12345678912",
            maskedNumber: "123.456.789-12",
            checkDigits: [1, 2],
            parts: ["123", "456", "789", "12"]
        )

        let parserInfo2 = Parser.Info(
            plainNumber: "12345678912",
            maskedNumber: "123.456.789-12",
            checkDigits: [1, 2],
            parts: ["123", "456", "789", "12"]
        )

        XCTAssertEqual(parserInfo1, parserInfo2)
    }
}

import XCTest
@testable import fazendinha

class ParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEquatableParserInfo() {
        let parserInfo1 = Parser.Info(plainNumber: "12345678912",
                                     maskedNumber: "123.456.789-12",
                                     checkDigits: [1, 2],
                                     parts: ["123", "456", "789", "12"])

        let parserInfo2 = Parser.Info(plainNumber: "12345678912",
                                      maskedNumber: "123.456.789-12",
                                      checkDigits: [1, 2],
                                      parts: ["123", "456", "789", "12"])

        XCTAssertEqual(parserInfo1, parserInfo2)
    }

}

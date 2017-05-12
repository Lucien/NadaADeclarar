import XCTest
import fazendinha

class CNPJTests: XCTestCase, ListImporter {

    var cnpjList: [CNPJ]!

    override func setUp() {
        super.setUp()
        self.cnpjList = CNPJTests.generatedNumberList()
    }

    func testValidCNPJ() throws {
        for cnpj in self.cnpjList {
            XCTAssertTrue(cnpj.isValid())
        }
    }

    func testGenerateCNPJ() {
        
        for _ in 0...1000 {
            XCTAssertTrue(CNPJ.generate().isValid())
        }
    }
}

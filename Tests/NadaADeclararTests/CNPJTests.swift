import XCTest
@testable import NadaADeclarar

class CNPJTests: XCTestCase, ListImporter {

    var cnpjList: Set<CNPJ>!

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

    func testCNPJSet() {
        XCTAssertEqual(self.cnpjList.count, 1001)
    }

    func testCNPJIsAHeadquarter() {
        XCTAssertTrue(try! CNPJ(number: "26.660.727/0001-99").isHeadquarters)
        XCTAssertFalse(try! CNPJ(number: "47.583.977/6467-51").isHeadquarters)
    }

    func testBranchNumber() {
        XCTAssertEqual(try! CNPJ(number: "26.660.727/0001-99").branchNumber, "0001")
        XCTAssertEqual(try! CNPJ(number: "47.583.977/6467-51").branchNumber, "6467")
    }
}

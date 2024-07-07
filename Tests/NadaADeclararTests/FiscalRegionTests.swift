import XCTest
@testable import NadaADeclarar

class FiscalRegionTests: XCTestCase {

    func testInvalidFiscalRegion() {
        let fiscalRegion = FiscalRegion(rawValue: 10)
        XCTAssertNil(fiscalRegion)
    }
}

import XCTest
@testable import fazendinha

class FiscalRegionTests: XCTestCase {

    func testInvalidFiscalRegion() {

        let fiscalRegion = FiscalRegion(rawValue: 10)
        XCTAssertNil(fiscalRegion)
    }
}

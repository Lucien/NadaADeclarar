import XCTest
@testable import NadaADeclarar

class CPFTests: XCTestCase, ListImporter {

    lazy var cpfGroup: Set<CPF>! = {
        return CPFTests.generatedNumberList()
    }()

    func testCPFSet() {

        XCTAssertEqual(cpfGroup.count, 1001)
    }

    func testCheckDigits() {

        let cpf = try! CPF(number: "125.609.581-80")
        XCTAssertEqual(cpf.checkDigits, [8, 0])
    }

    func testInvalidCPFInputFormatWith10Chars() throws {

        XCTAssertThrowsError(try CPF(number: "7715350466"), "") {
            (error: Error) in
            guard let cpfError = error as? Parser.InputError else {
                XCTFail()
                return
            }
            XCTAssertEqual(cpfError, .invalidFormat)
        }
    }

    func testInvalidCPFInputFormatWith11Chars() throws {

        XCTAssertThrowsError(try CPF(number: "1556122322A"), "") {
            (error: Error) in
            guard let cpfError = error as? Parser.InputError else {
                XCTFail()
                return
            }
            XCTAssertEqual(cpfError, .invalidFormat)
        }
    }

    func testInvalidCPFInputFormatWith14Chars() throws {

        XCTAssertThrowsError(try CPF(number: "155.612.232-2-"), "") {
            (error: Error) in
            guard let cpfError = error as? Parser.InputError else {
                XCTFail()
                return
            }
            XCTAssertEqual(cpfError, .invalidFormat)
        }
    }

    func testInvalidCPFInputFormatWith14CharsAndInvalidSeparators() throws {

        XCTAssertThrowsError(try CPF(number: "155-612-232-24"), "") {
            (error: Error) in
            guard let cpfError = error as? Parser.InputError else {
                XCTFail()
                return
            }
            XCTAssertEqual(cpfError, .invalidFormat)
        }
    }

    func testMaskedNumberFromPlainNumber() throws {

        let cpf = try CPF(number: "15561223224")
        XCTAssertEqual(cpf.maskedNumber, "155.612.232-24")
    }

    func testInvalidCPFsUsingFazendaAlgorythm() throws {

        XCTAssertFalse(try CPF(number: "000.000.000-00").isValid())
        XCTAssertFalse(try CPF(number: "111.111.111-11").isValid())
        XCTAssertFalse(try CPF(number: "222.222.222-22").isValid())
        XCTAssertFalse(try CPF(number: "333.333.333-33").isValid())
        XCTAssertFalse(try CPF(number: "444.444.444-44").isValid())
        XCTAssertFalse(try CPF(number: "555.555.555-55").isValid())
        XCTAssertFalse(try CPF(number: "666.666.666-66").isValid())
        XCTAssertFalse(try CPF(number: "777.777.777-77").isValid())
        XCTAssertFalse(try CPF(number: "888.888.888-88").isValid())
        XCTAssertFalse(try CPF(number: "999.999.999-99").isValid())
    }

    func testValidFazenda() {
        XCTAssertTrue(try CPF(number: "60258671432").isValid())
    }

    func testValidCPFsUsingFazendaAlgorythm() throws {

        XCTAssertTrue(try CPF(number: "100.000.987-44").isValid())
        XCTAssertTrue(try CPF(number: "520.852.930-00").isValid())
        XCTAssertTrue(try CPF(number: "000.000.001-91").isValid())
        XCTAssertTrue(try CPF(number: "544.780.212-10").isValid())
        XCTAssertTrue(try CPF(number: "813.219.583-31").isValid())
        XCTAssertTrue(try CPF(number: "602.586.714-32").isValid())
        XCTAssertTrue(try CPF(number: "334.028.435-01").isValid())
        XCTAssertTrue(try CPF(number: "545.462.246-05").isValid())
        XCTAssertTrue(try CPF(number: "135.991.648-27").isValid())
        XCTAssertTrue(try CPF(number: "286.714.209-14").isValid())

        XCTAssertTrue(try CPF(number: "728.793.773-58").isValid())
        XCTAssertTrue(try CPF(number: "704.881.802-60").isValid())
        XCTAssertTrue(try CPF(number: "508.584.317-77").isValid())
        XCTAssertTrue(try CPF(number: "517.531.566-88").isValid())

        XCTAssertTrue(try CPF(number: "050.505.834-03").isValid())
        XCTAssertTrue(try CPF(number: "337.718.534-86").isValid())
        XCTAssertTrue(try CPF(number: "827.525.778-69").isValid())
    }

    func testValidCPFsUsingSimpleAlgorythm() throws {

        XCTAssertTrue(try CPF(number: "10000098744").isValid(validationAlgorythm: .simple))
        XCTAssertTrue(try CPF(number: "520.852.930-00").isValid(validationAlgorythm: .simple))
        XCTAssertTrue(try CPF(number: "000.000.001-91").isValid(validationAlgorythm: .simple))
        XCTAssertTrue(try CPF(number: "544.780.212-10").isValid(validationAlgorythm: .simple))
        XCTAssertTrue(try CPF(number: "813.219.583-31").isValid(validationAlgorythm: .simple))
        XCTAssertTrue(try CPF(number: "602.586.714-32").isValid(validationAlgorythm: .simple))
        XCTAssertTrue(try CPF(number: "334.028.435-01").isValid(validationAlgorythm: .simple))
        XCTAssertTrue(try CPF(number: "545.462.246-05").isValid(validationAlgorythm: .simple))
        XCTAssertTrue(try CPF(number: "100.000.987-44").isValid(validationAlgorythm: .simple))
        XCTAssertTrue(try CPF(number: "135.991.648-27").isValid(validationAlgorythm: .simple))
        XCTAssertTrue(try CPF(number: "286.714.209-14").isValid(validationAlgorythm: .simple))

        XCTAssertTrue(try CPF(number: "728.793.773-58").isValid(validationAlgorythm: .simple))
        XCTAssertTrue(try CPF(number: "704.881.802-60").isValid(validationAlgorythm: .simple))
        XCTAssertTrue(try CPF(number: "508.584.317-77").isValid(validationAlgorythm: .simple))
        XCTAssertTrue(try CPF(number: "517.531.566-88").isValid(validationAlgorythm: .simple))

        XCTAssertTrue(try CPF(number: "050.505.834-03").isValid(validationAlgorythm: .simple))
        XCTAssertTrue(try CPF(number: "337.718.534-86").isValid(validationAlgorythm: .simple))
        XCTAssertTrue(try CPF(number: "827.525.778-69").isValid(validationAlgorythm: .simple))
    }

    func testFiscalRegion() throws {
        XCTAssertEqual(try CPF(number: "000.000.000-00").fiscalRegion, FiscalRegion.RF10)
        XCTAssertEqual(try CPF(number: "111.111.111-11").fiscalRegion, FiscalRegion.RF01)
        XCTAssertEqual(try CPF(number: "222.222.222-22").fiscalRegion, FiscalRegion.RF02)
        XCTAssertEqual(try CPF(number: "333.333.333-33").fiscalRegion, FiscalRegion.RF03)
        XCTAssertEqual(try CPF(number: "444.444.444-44").fiscalRegion, FiscalRegion.RF04)
        XCTAssertEqual(try CPF(number: "555.555.555-55").fiscalRegion, FiscalRegion.RF05)
        XCTAssertEqual(try CPF(number: "666.666.666-66").fiscalRegion, FiscalRegion.RF06)
        XCTAssertEqual(try CPF(number: "777.777.777-77").fiscalRegion, FiscalRegion.RF07)
        XCTAssertEqual(try CPF(number: "888.888.888-88").fiscalRegion, FiscalRegion.RF08)
        XCTAssertEqual(try CPF(number: "999.999.999-99").fiscalRegion, FiscalRegion.RF09)
    }

    func testStatesForFiscalRegion02() throws {
        let cpf = try CPF(number: "182.557.422-71")
        let states = Brazil.states.filter { (state: State) -> Bool in
            return state.fiscalRegion == .RF02
        }
        let statesSet = Set( states.map({ $0 }) )

        XCTAssertEqual(cpf.states, statesSet)
    }

    func testCPFGeneration() {
        for _ in 1...1000 {
            let cpf = CPF.generate()
            XCTAssertTrue(cpf.isValid())
        }
    }

    func testCPFValidationUsingSimpleMethod() {
        for cpf in self.cpfGroup {
            XCTAssertTrue(cpf.isValid(validationAlgorythm: .simple, allSameDigitsAreValid: false))
        }
    }

    func testSimpleAlgorithmsSpeed() throws {
        measure {
            for cpf in self.cpfGroup {
                _ = cpf.isValid(validationAlgorythm: Validator.ValidationAlgorythm.simple)
            }
        }
    }
}

import fazendinha
import XCTest

class StateTests: XCTestCase {

    var states: [State]!

    override func setUp() {
        super.setUp()
        states = 🇧🇷.states
    }

    func testNumberOfStates() {
        XCTAssertEqual(states.count, 27)
    }

    func testAcre() {

        let state = states[0]
        XCTAssertEqual(state.initials, "AC")
        XCTAssertEqual(state.name, "Acre")
        XCTAssertEqual(state.fiscalRegion, .fR2)
    }

    func testAlagoas() {

        let state = states[1]
        XCTAssertEqual(state.initials, "AL")
        XCTAssertEqual(state.name, "Alagoas")
        XCTAssertEqual(state.fiscalRegion, .fR4)
    }

    func testAmapa() {

        let state = states[2]
        XCTAssertEqual(state.initials, "AP")
        XCTAssertEqual(state.name, "Amapá")
        XCTAssertEqual(state.fiscalRegion, .fR2)
    }

    func testAmazonas() {

        let state = states[3]
        XCTAssertEqual(state.initials, "AM")
        XCTAssertEqual(state.name, "Amazonas")
        XCTAssertEqual(state.fiscalRegion, .fR2)
    }

    func testBahia() {

        let state = states[4]
        XCTAssertEqual(state.initials, "BA")
        XCTAssertEqual(state.name, "Bahia")
        XCTAssertEqual(state.fiscalRegion, .fR5)
    }

    func testCeara() {

        let state = states[5]
        XCTAssertEqual(state.initials, "CE")
        XCTAssertEqual(state.name, "Ceará")
        XCTAssertEqual(state.fiscalRegion, .fR3)
    }

    func testBrasilia() {

        let state = states[6]
        XCTAssertEqual(state.initials, "DF")
        XCTAssertEqual(state.name, "Brasília")
        XCTAssertEqual(state.fiscalRegion, .fR1)
    }

    func testEspiritoSanto() {

        let state = states[7]
        XCTAssertEqual(state.initials, "ES")
        XCTAssertEqual(state.name, "Espírito Santo")
        XCTAssertEqual(state.fiscalRegion, .fR7)
    }

    func testGoias() {

        let state = states[8]
        XCTAssertEqual(state.initials, "GO")
        XCTAssertEqual(state.name, "Goiás")
        XCTAssertEqual(state.fiscalRegion, .fR1)
    }

    func testMaranhao() {

        let state = states[9]
        XCTAssertEqual(state.initials, "MA")
        XCTAssertEqual(state.name, "Maranhão")
        XCTAssertEqual(state.fiscalRegion, .fR3)
    }

    func testMatoGrosso() {

        let state = states[10]
        XCTAssertEqual(state.initials, "MT")
        XCTAssertEqual(state.name, "Mato Grosso")
        XCTAssertEqual(state.fiscalRegion, .fR1)
    }

    func testMatoGrossoDoSul() {

        let state = states[11]
        XCTAssertEqual(state.initials, "MS")
        XCTAssertEqual(state.name, "Mato Grosso do Sul")
        XCTAssertEqual(state.fiscalRegion, .fR1)
    }

    func testMinasGerais() {

        let state = states[12]
        XCTAssertEqual(state.initials, "MG")
        XCTAssertEqual(state.name, "Minas Gerais")
        XCTAssertEqual(state.fiscalRegion, .fR6)
    }

    func testPara() {

        let state = states[13]
        XCTAssertEqual(state.initials, "PA")
        XCTAssertEqual(state.name, "Pará")
        XCTAssertEqual(state.fiscalRegion, .fR2)
    }

    func testParaiba() {

        let state = states[14]
        XCTAssertEqual(state.initials, "PB")
        XCTAssertEqual(state.name, "Paraíba")
        XCTAssertEqual(state.fiscalRegion, .fR4)
    }

    func testParana() {

        let state = states[15]
        XCTAssertEqual(state.initials, "PR")
        XCTAssertEqual(state.name, "Paraná")
        XCTAssertEqual(state.fiscalRegion, .fR9)
    }

    func testPernambuco() {

        let state = states[16]
        XCTAssertEqual(state.initials, "PE")
        XCTAssertEqual(state.name, "Pernambuco")
        XCTAssertEqual(state.fiscalRegion, .fR4)
    }

    func testPiaui() {

        let state = states[17]
        XCTAssertEqual(state.initials, "PI")
        XCTAssertEqual(state.name, "Piauí")
        XCTAssertEqual(state.fiscalRegion, .fR3)
    }

    func testRioDeJaneiro() {

        let state = states[18]
        XCTAssertEqual(state.initials, "RJ")
        XCTAssertEqual(state.name, "Rio de Janeiro")
        XCTAssertEqual(state.fiscalRegion, .fR7)
    }

    func testRioGrandeDoNorte() {

        let state = states[19]
        XCTAssertEqual(state.initials, "RN")
        XCTAssertEqual(state.name, "Rio Grande do Norte")
        XCTAssertEqual(state.fiscalRegion, .fR4)
    }

    func testRioGrandeDoSul() {

        let state = states[20]
        XCTAssertEqual(state.initials, "RS")
        XCTAssertEqual(state.name, "Rio Grande do Sul")
        XCTAssertEqual(state.fiscalRegion, .fR10)
    }

    func testRondonia() {

        let state = states[21]
        XCTAssertEqual(state.initials, "RO")
        XCTAssertEqual(state.name, "Rondônia")
        XCTAssertEqual(state.fiscalRegion, .fR2)
    }

    func testRoraima() {

        let state = states[22]
        XCTAssertEqual(state.initials, "RR")
        XCTAssertEqual(state.name, "Roraima")
        XCTAssertEqual(state.fiscalRegion, .fR2)
    }

    func testSantaCatarina() {

        let state = states[23]
        XCTAssertEqual(state.initials, "SC")
        XCTAssertEqual(state.name, "Santa Catarina")
        XCTAssertEqual(state.fiscalRegion, .fR9)
    }

    func testSaoPaulo() {

        let state = states[24]
        XCTAssertEqual(state.initials, "SP")
        XCTAssertEqual(state.name, "São Paulo")
        XCTAssertEqual(state.fiscalRegion, .fR8)
    }

    func testSergipe() {

        let state = states[25]
        XCTAssertEqual(state.initials, "SE")
        XCTAssertEqual(state.name, "Sergipe")
        XCTAssertEqual(state.fiscalRegion, .fR5)
    }
    
    func testTocantins() {
        
        let state = states[26]
        XCTAssertEqual(state.initials, "TO")
        XCTAssertEqual(state.name, "Tocantins")
        XCTAssertEqual(state.fiscalRegion, .fR1)
    }
}

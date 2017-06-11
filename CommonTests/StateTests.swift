import XCTest
@testable import fazendinha

class StateTests: XCTestCase {

    var states: Set<State>!

    override func setUp() {
        super.setUp()
        states = Brazil.states
    }

    func testNumberOfStates() {
        XCTAssertEqual(states.count, 27)
    }

    func testDescription() {

        let state = State(initials: "HUE", name: "Hueland", fiscalRegion: .fR1)
        XCTAssertEqual(state.description, "State: Hueland (HUE) Fiscal Region: fR1")
    }

    func testAcre() {
        let state = states.filter { (state: State) -> Bool in
            return state.initials == "AC"
        }.first!

        XCTAssertEqual(state.name, "Acre")
        XCTAssertEqual(state.fiscalRegion, .fR2)
    }

    func testAlagoas() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "AL"
            }.first!
        XCTAssertEqual(state.name, "Alagoas")
        XCTAssertEqual(state.fiscalRegion, .fR4)
    }

    func testAmapa() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "AP"
            }.first!
        XCTAssertEqual(state.name, "Amapá")
        XCTAssertEqual(state.fiscalRegion, .fR2)
    }

    func testAmazonas() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "AM"
            }.first!
        XCTAssertEqual(state.name, "Amazonas")
        XCTAssertEqual(state.fiscalRegion, .fR2)
    }

    func testBahia() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "BA"
            }.first!
        XCTAssertEqual(state.name, "Bahia")
        XCTAssertEqual(state.fiscalRegion, .fR5)
    }

    func testCeara() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "CE"
            }.first!
        XCTAssertEqual(state.name, "Ceará")
        XCTAssertEqual(state.fiscalRegion, .fR3)
    }

    func testBrasilia() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "DF"
            }.first!
        XCTAssertEqual(state.name, "Brasília")
        XCTAssertEqual(state.fiscalRegion, .fR1)
    }

    func testEspiritoSanto() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "ES"
            }.first!
        XCTAssertEqual(state.name, "Espírito Santo")
        XCTAssertEqual(state.fiscalRegion, .fR7)
    }

    func testGoias() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "GO"
            }.first!
        XCTAssertEqual(state.name, "Goiás")
        XCTAssertEqual(state.fiscalRegion, .fR1)
    }

    func testMaranhao() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "MA"
            }.first!
        XCTAssertEqual(state.name, "Maranhão")
        XCTAssertEqual(state.fiscalRegion, .fR3)
    }

    func testMatoGrosso() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "MT"
            }.first!
        XCTAssertEqual(state.name, "Mato Grosso")
        XCTAssertEqual(state.fiscalRegion, .fR1)
    }

    func testMatoGrossoDoSul() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "MS"
            }.first!
        XCTAssertEqual(state.name, "Mato Grosso do Sul")
        XCTAssertEqual(state.fiscalRegion, .fR1)
    }

    func testMinasGerais() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "MG"
            }.first!
        XCTAssertEqual(state.name, "Minas Gerais")
        XCTAssertEqual(state.fiscalRegion, .fR6)
    }

    func testPara() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "PA"
            }.first!
        XCTAssertEqual(state.name, "Pará")
        XCTAssertEqual(state.fiscalRegion, .fR2)
    }

    func testParaiba() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "PB"
            }.first!
        XCTAssertEqual(state.name, "Paraíba")
        XCTAssertEqual(state.fiscalRegion, .fR4)
    }

    func testParana() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "PR"
            }.first!
        XCTAssertEqual(state.name, "Paraná")
        XCTAssertEqual(state.fiscalRegion, .fR9)
    }

    func testPernambuco() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "PE"
            }.first!
        XCTAssertEqual(state.name, "Pernambuco")
        XCTAssertEqual(state.fiscalRegion, .fR4)
    }

    func testPiaui() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "PI"
            }.first!
        XCTAssertEqual(state.name, "Piauí")
        XCTAssertEqual(state.fiscalRegion, .fR3)
    }

    func testRioDeJaneiro() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "RJ"
            }.first!
        XCTAssertEqual(state.name, "Rio de Janeiro")
        XCTAssertEqual(state.fiscalRegion, .fR7)
    }

    func testRioGrandeDoNorte() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "RN"
            }.first!
        XCTAssertEqual(state.name, "Rio Grande do Norte")
        XCTAssertEqual(state.fiscalRegion, .fR4)
    }

    func testRioGrandeDoSul() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "RS"
            }.first!
        XCTAssertEqual(state.name, "Rio Grande do Sul")
        XCTAssertEqual(state.fiscalRegion, .fR10)
    }

    func testRondonia() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "RO"
            }.first!
        XCTAssertEqual(state.name, "Rondônia")
        XCTAssertEqual(state.fiscalRegion, .fR2)
    }

    func testRoraima() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "RR"
            }.first!
        XCTAssertEqual(state.name, "Roraima")
        XCTAssertEqual(state.fiscalRegion, .fR2)
    }

    func testSantaCatarina() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "SC"
            }.first!
        XCTAssertEqual(state.name, "Santa Catarina")
        XCTAssertEqual(state.fiscalRegion, .fR9)
    }

    func testSaoPaulo() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "SP"
            }.first!
        XCTAssertEqual(state.name, "São Paulo")
        XCTAssertEqual(state.fiscalRegion, .fR8)
    }

    func testSergipe() {

        let state = states.filter { (state: State) -> Bool in
            return state.initials == "SE"
            }.first!
        XCTAssertEqual(state.name, "Sergipe")
        XCTAssertEqual(state.fiscalRegion, .fR5)
    }
    
    func testTocantins() {
        
        let state = states.filter { (state: State) -> Bool in
            return state.initials == "TO"
            }.first!
        XCTAssertEqual(state.name, "Tocantins")
        XCTAssertEqual(state.fiscalRegion, .fR1)
    }
}

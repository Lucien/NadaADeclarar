/// Enum representing the fiscal regions as defined by the Receita Federal in Brazil.
///
/// Each case corresponds to a fiscal region identified by the last digit in the CPF number before the check digits.
/// This digit helps determine the specific fiscal region for tax and administrative purposes.
public enum FiscalRegion: Int, Equatable {
    case RF01 = 1
    case RF02 = 2
    case RF03 = 3
    case RF04 = 4
    case RF05 = 5
    case RF06 = 6
    case RF07 = 7
    case RF08 = 8
    case RF09 = 9
    case RF10 = 0
}

public struct State {
    public let initials: String
    public let name: String
    public let fiscalRegion: FiscalRegion
}

extension State: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(initials)
        hasher.combine(name)
        hasher.combine(fiscalRegion)
    }

    public static func == (lhs: State, rhs: State) -> Bool {
        return (
            lhs.initials == rhs.initials &&
            lhs.name == rhs.name &&
            lhs.fiscalRegion == rhs.fiscalRegion
        )
    }
}

extension State: CustomStringConvertible {
    public var description: String {
        return "State: \(name) (\(initials)) Fiscal Region: \(fiscalRegion)"
    }
}

public struct Brazil {

    public static let states: Set<State> =
    [
        State(initials: "AC", name: "Acre", fiscalRegion: .RF02),
        State(initials: "AL", name: "Alagoas", fiscalRegion: .RF04),
        State(initials: "AP", name: "Amapá", fiscalRegion: .RF02),
        State(initials: "AM", name: "Amazonas", fiscalRegion: .RF02),
        State(initials: "BA", name: "Bahia", fiscalRegion: .RF05),
        State(initials: "CE", name: "Ceará", fiscalRegion: .RF03),
        State(initials: "DF", name: "Brasília", fiscalRegion: .RF01),
        State(initials: "ES", name: "Espírito Santo", fiscalRegion: .RF07),
        State(initials: "GO", name: "Goiás", fiscalRegion: .RF01),
        State(initials: "MA", name: "Maranhão", fiscalRegion: .RF03),
        State(initials: "MT", name: "Mato Grosso", fiscalRegion: .RF01),
        State(initials: "MS", name: "Mato Grosso do Sul", fiscalRegion: .RF01),
        State(initials: "MG", name: "Minas Gerais", fiscalRegion: .RF06),
        State(initials: "PA", name: "Pará", fiscalRegion: .RF02),
        State(initials: "PB", name: "Paraíba", fiscalRegion: .RF04),
        State(initials: "PR", name: "Paraná", fiscalRegion: .RF09),
        State(initials: "PE", name: "Pernambuco", fiscalRegion: .RF04),
        State(initials: "PI", name: "Piauí", fiscalRegion: .RF03),
        State(initials: "RJ", name: "Rio de Janeiro", fiscalRegion: .RF07),
        State(initials: "RN", name: "Rio Grande do Norte", fiscalRegion: .RF04),
        State(initials: "RS", name: "Rio Grande do Sul", fiscalRegion: .RF10),
        State(initials: "RO", name: "Rondônia", fiscalRegion: .RF02),
        State(initials: "RR", name: "Roraima", fiscalRegion: .RF02),
        State(initials: "SC", name: "Santa Catarina", fiscalRegion: .RF09),
        State(initials: "SP", name: "São Paulo", fiscalRegion: .RF08),
        State(initials: "SE", name: "Sergipe", fiscalRegion: .RF05),
        State(initials: "TO", name: "Tocantins", fiscalRegion: .RF01)
    ]
}

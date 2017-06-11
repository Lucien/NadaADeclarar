import Foundation

public struct State {
    public let initials: String
    public let name: String
    public let fiscalRegion: FiscalRegion
}

extension State: Hashable {

    public var hashValue: Int {
        return (initials.hashValue ^
            name.hashValue ^
            fiscalRegion.hashValue)
    }

    public static func == (lhs: State, rhs: State) -> Bool {
        return lhs.initials == rhs.initials &&
            lhs.name == rhs.name &&
            lhs.fiscalRegion == rhs.fiscalRegion
    }
}

extension State: CustomStringConvertible {
    public var description: String {
        return "State: \(name) (\(initials)) Fiscal Region: \(fiscalRegion)"
    }
}

public struct Brazil {

    public static let states: Set<State> =
        [State(initials: "AC", name: "Acre", fiscalRegion: .fR2),
         State(initials: "AL", name: "Alagoas", fiscalRegion: .fR4),
         State(initials: "AP", name: "Amapá", fiscalRegion: .fR2),
         State(initials: "AM", name: "Amazonas", fiscalRegion: .fR2),
         State(initials: "BA", name: "Bahia", fiscalRegion: .fR5),
         State(initials: "CE", name: "Ceará", fiscalRegion: .fR3),
         State(initials: "DF", name: "Brasília", fiscalRegion: .fR1),
         State(initials: "ES", name: "Espírito Santo", fiscalRegion: .fR7),
         State(initials: "GO", name: "Goiás", fiscalRegion: .fR1),
         State(initials: "MA", name: "Maranhão", fiscalRegion: .fR3),
         State(initials: "MT", name: "Mato Grosso", fiscalRegion: .fR1),
         State(initials: "MS", name: "Mato Grosso do Sul", fiscalRegion: .fR1),
         State(initials: "MG", name: "Minas Gerais", fiscalRegion: .fR6),
         State(initials: "PA", name: "Pará", fiscalRegion: .fR2),
         State(initials: "PB", name: "Paraíba", fiscalRegion: .fR4),
         State(initials: "PR", name: "Paraná", fiscalRegion: .fR9),
         State(initials: "PE", name: "Pernambuco", fiscalRegion: .fR4),
         State(initials: "PI", name: "Piauí", fiscalRegion: .fR3),
         State(initials: "RJ", name: "Rio de Janeiro", fiscalRegion: .fR7),
         State(initials: "RN", name: "Rio Grande do Norte", fiscalRegion: .fR4),
         State(initials: "RS", name: "Rio Grande do Sul", fiscalRegion: .fR10),
         State(initials: "RO", name: "Rondônia", fiscalRegion: .fR2),
         State(initials: "RR", name: "Roraima", fiscalRegion: .fR2),
         State(initials: "SC", name: "Santa Catarina", fiscalRegion: .fR9),
         State(initials: "SP", name: "São Paulo", fiscalRegion: .fR8),
         State(initials: "SE", name: "Sergipe", fiscalRegion: .fR5),
         State(initials: "TO", name: "Tocantins", fiscalRegion: .fR1)]
}

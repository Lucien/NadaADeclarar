import Foundation

public enum FiscalRegion: Int, RawRepresentable {
    case fR1 = 1
    case fR2
    case fR3
    case fR4
    case fR5
    case fR6
    case fR7
    case fR8
    case fR9
    case fR10

    public init?(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .fR10
        case 1:
            self = .fR1
        case 2:
            self = .fR2
        case 3:
            self = .fR3
        case 4:
            self = .fR4
        case 5:
            self = .fR5
        case 6:
            self = .fR6
        case 7:
            self = .fR7
        case 8:
            self = .fR8
        case 9:
            self = .fR9
        default:
            return nil
        }
    }
}

extension FiscalRegion: Equatable {
    public static func ==(lhs: FiscalRegion, rhs: FiscalRegion) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

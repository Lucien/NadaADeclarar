import Foundation

public enum FiscalRegion: Int {
    case fR10 = 0
    case fR1
    case fR2
    case fR3
    case fR4
    case fR5
    case fR6
    case fR7
    case fR8
    case fR9
}

extension FiscalRegion: Equatable {
    public static func ==(lhs: FiscalRegion, rhs: FiscalRegion) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

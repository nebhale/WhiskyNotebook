// Copyright 2014-2015 Ben Hale. All Rights Reserved

public enum Level: Int {
    case Debug
    case Info
    case Warn
    case Error
}

// MARK: - Printable
extension Level: Printable {
    public var description: String { return "<Level: \(self.rawValue)>" }
}

// MARK: - String Representation
extension Level {

    public static func fromString(string: String) -> Level {
        switch(string) {
        case let value where value =~ (Level.Debug.toString(), true):
            return .Debug
        case let value where value =~ (Level.Info.toString(), true):
            return .Info
        case let value where value =~ (Level.Warn.toString(), true):
            return .Warn
        case let value where value =~ (Level.Error.toString(), true):
            return .Error
        default:
            return .Debug
        }
    }

    public func toString() -> String {
        switch(self) {
        case .Debug:
            return "Debug"
        case .Info:
            return "Info"
        case .Warn:
            return "Warn"
        case .Error:
            return "Error"
        }
    }
}

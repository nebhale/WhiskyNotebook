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
        case "debug", "DEBUG", "Debug":
            return .Debug
        case "info", "INFO", "Info":
            return .Info
        case "warn", "WARN", "Warn":
            return .Warn
        case "error", "ERROR", "Error":
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

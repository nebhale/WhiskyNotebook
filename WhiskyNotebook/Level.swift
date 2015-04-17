// Copyright 2014-2015 Ben Hale. All Rights Reserved

public enum Level: Int {
    case Debug
    case Info
    case Warn
    case Error

    public init(_ string: String) {
        switch(string) {
        case let value where value =~ (Level.Debug.toString(), true):
            self = .Debug
        case let value where value =~ (Level.Info.toString(), true):
            self = .Info
        case let value where value =~ (Level.Warn.toString(), true):
            self = .Warn
        case let value where value =~ (Level.Error.toString(), true):
            self = .Error
        default:
            self = .Debug
        }
    }
}

// MARK: - Printable
extension Level: Printable {
    public var description: String { return "<Level: \(self.rawValue)>" }
}

// MARK: - String Representation
extension Level {
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

// Copyright 2014-2015 Ben Hale. All Rights Reserved


public enum Rating: Int {
    case Positive
    case Neutral
    case Negative
}

// MARK - Printable
extension Rating: Printable {
    public var description: String { return "<Rating: \(self.rawValue)>" }
}
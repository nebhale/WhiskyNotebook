// Copyright 2014-2015 Ben Hale. All Rights Reserved

public struct Configuration {

    public let name: String

    public var level = Level.Info

    public var format = "%date{HH:mm:ss} %level %message"

    public init(name: String) {
        self.name = name
    }
}

extension Configuration: Equatable {}
public func ==(x: Configuration, y: Configuration) -> Bool {
    return x.name == y.name
}

extension Configuration: Hashable {
    public var hashValue: Int {
        return self.name.hashValue
    }
}

extension Configuration: Printable {
    public var description: String { return "<Configuration: \(self.name); level=\(self.level), format=\(self.format)>"}
}
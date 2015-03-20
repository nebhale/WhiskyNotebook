// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation

public struct Memento: Equatable, Hashable {

    private let id: NSUUID

    public var hashValue: Int { return self.id.hashValue }

    public init() {
        self.id = NSUUID()
    }

    public init(id: NSUUID) {
        self.id = id
    }
    
}


public func ==(x: Memento, y: Memento) -> Bool {
    return x.id == y.id
}

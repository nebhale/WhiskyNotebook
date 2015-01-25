// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Foundation


final class Memento: Equatable, Hashable {
    
    private let id = NSUUID()
    
    var hashValue: Int { return self.id.hashValue }
    
}

func ==(x: Memento, y: Memento) -> Bool {
    return x.id == y.id
}
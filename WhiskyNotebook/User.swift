// Copyright 2014-2015 Ben Hale. All Rights Reserved

final class User: Equatable, Hashable, Printable {
    
    let id: String
    
    let name: String?
    
    let membership: String?
    
    var description: String {
        return "<User: \(self.id); name=\(self.name), membership=\(self.membership)>"
    }
    
    var hashValue: Int {
        return self.id.hashValue
    }
    
    init(id: String, name: String?, membership: String?) {
        self.id = id
        self.name = name
        self.membership = membership
    }
    
}

func ==(x: User, y: User) -> Bool {
    return x.id == y.id
}
// Copyright 2014 Ben Hale. All Rights Reserved

final class Section<T>: Printable {
    
    let key: T
    
    var distilleries: [Distillery] = []
    
    var description: String {
        get {
            return "Section \(self.key)"
        }
    }
    
    init(_ key: T) {
        self.key = key
    }
    
}
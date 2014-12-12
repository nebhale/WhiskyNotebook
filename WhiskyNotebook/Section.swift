// Copyright 2014 Ben Hale. All Rights Reserved

final class Section<T> {
    
    let key: T
    
    var distilleries: [Distillery] = []
    
    init(_ key: T) {
        self.key = key
    }
    
}
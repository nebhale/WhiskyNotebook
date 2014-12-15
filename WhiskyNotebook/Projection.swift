// Copyright 2014 Ben Hale. All Rights Reserved

protocol Projection {
    
    func at(index: Int) -> Distillery
    
    func count() -> Int
    
    func source() -> [Distillery]
    
}

// Copyright 2014 Ben Hale. All Rights Reserved

final class StandardProjection: Projection {
    
    // MARK: Properties
    
    private let distilleries: [Distillery]
    
    private let logger = Logger("StandardProjection")
    
    // MARK: Initializers
    
    init(_ distilleries: [Distillery]) {
        self.distilleries = distilleries
    }
    
    // MARK: Projection
    
    func at(index: Int) -> Distillery {
        return self.distilleries[index]
    }
    
    func count() -> Int {
        return self.distilleries.count
    }
    
    func source() -> [Distillery] {
        return self.distilleries
    }
    
}


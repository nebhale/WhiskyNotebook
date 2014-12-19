// Copyright 2014 Ben Hale. All Rights Reserved

final class StandardProjection: Projection {
    
    private let distilleries: [Distillery]
    
    private let logger = Logger("StandardProjection")
    
    init(_ distilleries: [Distillery]) {
        self.distilleries = distilleries
    }
    
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


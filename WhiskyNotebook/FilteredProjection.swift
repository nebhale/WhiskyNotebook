// Copyright 2014 Ben Hale. All Rights Reserved

import UIKit

final class FilteredProjection: Projection {
    
    // MARK: Properties
    
    private let distilleries: [Distillery]
    
    private let filtered: [Distillery]
    
    private let logger = Logger("FilteredProject")
    
    // MARK: Initializers
    
    init(_ distilleries: [Distillery]?, _ substring: String = "") {
        if let distilleries = distilleries {
            self.distilleries = distilleries
        } else {
            self.distilleries = []
        }
        
        self.filtered = self.distilleries.filter { distillery in
            return distillery.id.containsIgnoreCase(substring) || distillery.name.containsIgnoreCase(substring) || distillery.region.rawValue.containsIgnoreCase(substring)
        }
        
        self.logger.debug { "Filtered from \(self.distilleries.count) to \(self.filtered.count)" }
    }
    
    // MARK: Projection
    
    func at(index: Int) -> Distillery {
        return self.filtered[index]
    }
    
    func count() -> Int {
        return self.filtered.count
    }
    
    func source() -> [Distillery] {
        return self.distilleries
    }
    
}
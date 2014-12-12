// Copyright 2014 Ben Hale. All Rights Reserved

import UIKit

final class FilteredSectionProjection : SectionProjection {
    
    private let logger = Logger("FilteredSectionProject")
    
    private let distilleries: [Distillery]
    
    private let filtered: [Distillery]
    
    init(_ distilleries: [Distillery], _ filter: (Distillery) -> (Bool)) {
        self.distilleries = distilleries
        self.filtered = distilleries.filter(filter)
        
        self.logger.debug { "Filtered from \(self.distilleries.count) to \(self.filtered.count)" }
    }
    
    convenience init(_ sectionProjection: SectionProjection, _ filter: (Distillery) -> (Bool)) {
        self.init(sectionProjection.source(), filter)
    }
    
    func at(indexPath: NSIndexPath) -> Distillery {
        return self.filtered[indexPath.row]
    }
    
    func distilleryCount(section: Int) -> Int {
        return self.filtered.count
    }
    
    func sectionCount() -> Int {
        return 1
    }
    
    func sectionIndexTitles() -> [String] {
        return []
    }
    
    func sectionTitle(section: Int) -> String? {
        return nil
    }
    
    func source() -> [Distillery] {
        return self.distilleries
    }
}
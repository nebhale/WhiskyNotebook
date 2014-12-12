// Copyright 2014 Ben Hale. All Rights Reserved

import UIKit

class AbstractSectionProjection<T where T: Comparable, T: Equatable> : SectionProjection {
    
    private let distilleries: [Distillery]
    
    private var sections: [Section<T>]
    
    init(_ distilleries: [Distillery], _ sections: [Section<T>]) {
        self.distilleries = distilleries
        self.sections = sections
        
        for distillery in self.distilleries {
            self.section(key(distillery)[0]).distilleries.append(distillery)
        }
        
        self.sections.sort { a, b in
            if let aKey = (a.key as? String)?.toInt() {
                if let bKey = (b.key as? String)?.toInt() {
                    return aKey < bKey
                }
            }
            
            return a.key < b.key
        }
        
        for section in self.sections {
            section.distilleries.sort { $0 < $1 }
        }
    }
    
    // TODO: There appears to be a bug returning T.  Each release, you should attempt to remove this work around
    func key(distillery: Distillery) -> [T] {
        assert(false, "This method must be implemented by a child class")
    }
    
    func sectionIndexTitle(section: Section<T>) -> String? {
        assert(false, "This method must be implemented by a child class")
    }
    
    func sectionTitle(section: Section<T>) -> String? {
        assert(false, "This method must be implemented by a child class")
    }
    
    final func at(indexPath: NSIndexPath) -> Distillery {
        return self.sections[indexPath.section].distilleries[indexPath.row]
    }
    
    final func distilleryCount(section: Int) -> Int {
        return self.sections[section].distilleries.count
    }
    
    final func sectionCount() -> Int {
        return self.sections.count
    }
    
    final func sectionIndexTitles() -> [String] {
        var sectionIndexTitles: [String] = []
        
        for section in self.sections {
            if let sectionIndexTitle = sectionIndexTitle(section) {
                sectionIndexTitles.append(sectionIndexTitle)
            }
        }
        
        return sectionIndexTitles
    }
    
    final func sectionTitle(section: Int) -> String? {
        let section = self.sections[section]
        return section.distilleries.isEmpty ? nil : sectionTitle(section)
    }
    
    final func source() -> [Distillery] {
        return self.distilleries
    }

    private func section(key: T) -> Section<T> {
        for section in self.sections {
            if section.key == key {
                return section
            }
        }
        
        let section = Section(key)
        self.sections.append(section)
        return section
    }
}


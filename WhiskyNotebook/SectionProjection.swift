// Copyright 2014 Ben Hale. All Rights Reserved

import UIKit

protocol SectionProjection {
    
    func at(indexPath: NSIndexPath) -> Distillery
    
    func distilleryCount(section: Int) -> Int
    
    func sectionCount() -> Int
    
    func sectionIndexTitles() -> [String]
    
    func sectionTitle(section: Int) -> String?
    
    func source() -> [Distillery]
    
}

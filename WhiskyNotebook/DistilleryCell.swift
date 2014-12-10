// Copyright 2014 Ben Hale. All Rights Reserved

import UIKit

final class DistilleryCell: UITableViewCell {
    
    func loadItem(distillery: Distillery) {
        self.textLabel?.text = "\(distillery.id) \(distillery.name)"
        self.detailTextLabel?.text = distillery.region.rawValue

    }
    
}

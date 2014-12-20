// Copyright 2014 Ben Hale. All Rights Reserved

import UIKit

final class DistilleryCell: UITableViewCell {
    
    @IBOutlet
    var id: UILabel?

    @IBOutlet
    var name: UILabel?

    @IBOutlet
    var region: UILabel?

    func loadItem(distillery: Distillery) {
        self.id?.text = distillery.id
        self.name?.text = distillery.name
        self.region?.text = distillery.region.rawValue
    }
    
}

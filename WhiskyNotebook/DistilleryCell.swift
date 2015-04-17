// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa
import UIKit


public final class DistilleryCell: UITableViewCell {

    @IBOutlet
    public var id: UILabel!

    @IBOutlet
    public var name: UILabel!

    @IBOutlet
    public var region: UILabel!

    public func configure(distillery: Distillery) {
        self.id.text = distillery.id
        self.name.text = distillery.name
        self.region.text = distillery.region?.rawValue
    }
    
}
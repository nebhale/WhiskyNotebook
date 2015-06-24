// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import LoggerLogger
import UIKit


final class DistilleryCell: UITableViewCell {

    @IBOutlet
    var id: UILabel!

    private let logger = Logger()

    @IBOutlet
    var name: UILabel!

    @IBOutlet
    var region: UILabel!

    // MARK: -

    func configureWithDistillery(distillery: Distillery) {
        self.logger.debug("Configuring with \(distillery)")

        self.id.text = distillery.id
        self.name.text = distillery.name
        self.region.text = distillery.region?.rawValue
    }
}
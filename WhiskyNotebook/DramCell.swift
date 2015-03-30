// Copyright 2014-2015 Ben Hale. All Rights Reserved

import UIKit


public class DramCell: UITableViewCell {

    @IBOutlet
    public var date: UILabel!

    @IBOutlet
    public var id: UILabel!

    private let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        return dateFormatter
    }()

    public func configure(dram: Dram) {
        self.id.text = dram.id

        if let date = dram.date {
            self.date.text = dateFormatter.stringFromDate(date)
        }
    }
}
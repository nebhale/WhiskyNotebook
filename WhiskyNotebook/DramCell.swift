// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa
import UIKit


public final class DramCell: UITableViewCell {

    @IBOutlet
    public var date: UILabel!

    private let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        return dateFormatter
        }()

    @IBOutlet
    public var id: UILabel!

    @IBOutlet
    public var rating: UISegmentedControl!

    public func configure(dram: Dram) {
        self.date.text = dram.date != nil ? self.dateFormatter.stringFromDate(dram.date!) : nil
        self.id.text = dram.id
        self.rating.selectedSegmentIndex = dram.rating?.rawValue ?? UISegmentedControlNoSegment
    }
}
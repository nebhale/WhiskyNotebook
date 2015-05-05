// Copyright 2014-2015 Ben Hale. All Rights Reserved


import ReactiveCocoa
import UIKit

final class DramCell: UITableViewCell {

    @IBOutlet
    var date: UILabel!

    private let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        return dateFormatter
        }()

    @IBOutlet
    var id: UILabel!

    @IBOutlet
    var rating: UISegmentedControl!

    func configure(dram: Dram) {
        self.date.text = dram.date != nil ? self.dateFormatter.stringFromDate(dram.date!) : nil
        self.id.text = dram.id
        self.rating.selectedSegmentIndex = dram.rating?.rawValue ?? UISegmentedControlNoSegment
    }
}
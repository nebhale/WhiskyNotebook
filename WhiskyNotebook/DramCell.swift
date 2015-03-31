// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa
import UIKit


public class DramCell: UITableViewCell {

    @IBOutlet
    public var date: UILabel!

    private let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        return dateFormatter
        }()

    public let dram = MutableProperty<Dram>(Dram())

    @IBOutlet
    public var id: UILabel!

    private let logger = Logger()

    @IBOutlet
    public var rating: UISegmentedControl!
}

// MARK: - Interface Update
extension DramCell {
    public override func layoutSubviews() {
        super.layoutSubviews()

        DynamicProperty(object: self.date, keyPath: "text") <~ self.dram.producer
            |> map { dram in
                if let date = dram.date {
                    return self.dateFormatter.stringFromDate(date)
                } else {
                    return nil
                }
        }

        DynamicProperty(object: self.id, keyPath: "text") <~ self.dram.producer
            |> map { $0.id }

        DynamicProperty(object: self.rating, keyPath: "enabled") <~ self.dram.producer
            |> map { $0.rating == nil }

        DynamicProperty(object: self.rating, keyPath: "selectedSegmentIndex") <~ self.dram.producer
            |> map { dram in
                if let rating = dram.rating {
                    return rating.rawValue
                } else {
                    return UISegmentedControlNoSegment
                }
        }
    }
}
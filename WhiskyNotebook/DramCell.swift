// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa
import UIKit


public final class DramCell: UITableViewCell {

    private let dram = MutableProperty<Dram>(Dram())

    @IBOutlet
    public var date: UILabel! {
        didSet {
            DynamicProperty(object: self.date, keyPath: "text") <~ self.dram.producer
                |> observeOn(UIScheduler())
                |> map { dram in
                    if let date = dram.date {
                        return self.dateFormatter.stringFromDate(date)
                    } else {
                        return nil
                    }
            }
        }
    }

    private let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        return dateFormatter
        }()

    @IBOutlet
    public var id: UILabel! {
        didSet {
            DynamicProperty(object: self.id, keyPath: "text") <~ self.dram.producer
                |> observeOn(UIScheduler())
                |> map { $0.id }
        }
    }

    private let logger = Logger()

    @IBOutlet
    public var rating: UISegmentedControl! {
        didSet {
            DynamicProperty(object: self.rating, keyPath: "enabled") <~ self.dram.producer
                |> observeOn(UIScheduler())
                |> map { $0.rating == nil }

            DynamicProperty(object: self.rating, keyPath: "selectedSegmentIndex") <~ self.dram.producer
                |> observeOn(UIScheduler())
                |> map { dram in
                    if let rating = dram.rating {
                        return rating.rawValue
                    } else {
                        return UISegmentedControlNoSegment
                    }
            }

            self.rating.rac_newSelectedSegmentIndexChannelWithNilValue(UISegmentedControlNoSegment).toSignalProducer()
                |> map(updatedDram)
                |> observeOn(QueueScheduler())
                |> start(next: {
                    self.logger.info("Save initiated")
                    self.repository.save($0)
                })
        }
    }

    public var repository = DramRepositoryManager.sharedInstance

    public func configure(dram: Dram) {
        self.dram.value = dram
    }

    private func updatedDram(selectedSegmentIndex: AnyObject?) -> Dram {
        var dram = self.dram.value
        dram.rating = (selectedSegmentIndex as? Int)?.toRating()
        return dram
    }
}
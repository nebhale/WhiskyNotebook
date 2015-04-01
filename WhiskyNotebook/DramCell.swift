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

    public var repository = DramRepositoryManager.sharedInstance

    public override func layoutSubviews() {
        super.layoutSubviews()

        initInterfaceUpdate()
        initSave()
    }
}

// MARK: - Interface Update
extension DramCell {
    private func initInterfaceUpdate() {
        DynamicProperty(object: self.date, keyPath: "text") <~ self.dram.producer
            |> observeOn(UIScheduler())
            |> map { dram in
                if let date = dram.date {
                    return self.dateFormatter.stringFromDate(date)
                } else {
                    return nil
                }
        }

        DynamicProperty(object: self.id, keyPath: "text") <~ self.dram.producer
            |> observeOn(UIScheduler())
            |> map { $0.id }

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
    }
}



// MARK: - Save
extension DramCell {
    private func initSave() {
        self.rating.rac_signalForControlEvents(.ValueChanged).toSignalProducer()
            |> map { ($0 as? UISegmentedControl)?.selectedSegmentIndex.toRating() }
            |> start(next: { rating in
                self.logger.info("Save initiated")

                var dram = self.dram.value
                dram.rating = rating

                SignalProducer<Dram, NoError>(value: dram)
                    |> observeOn(QueueScheduler())
                    |> start(next: { self.repository.save($0) })
            })
    }
}
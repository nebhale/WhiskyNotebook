// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa
import UIKit


public final class DramCell: UITableViewCell {

    public let currentDram = MutableProperty<Dram>(Dram())

    @IBOutlet
    public var date: UILabel!

    private let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        return dateFormatter
        }()

    @IBOutlet
    public var identifier: UILabel!

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
        DynamicProperty(object: self.date, keyPath: "text") <~ self.currentDram.producer
            |> observeOn(UIScheduler())
            |> map { dram in
                if let date = dram.date {
                    return self.dateFormatter.stringFromDate(date)
                } else {
                    return nil
                }
        }

        DynamicProperty(object: self.identifier, keyPath: "text") <~ self.currentDram.producer
            |> observeOn(UIScheduler())
            |> map { $0.identifier }

        DynamicProperty(object: self.rating, keyPath: "enabled") <~ self.currentDram.producer
            |> observeOn(UIScheduler())
            |> map { $0.rating == nil }

        DynamicProperty(object: self.rating, keyPath: "selectedSegmentIndex") <~ self.currentDram.producer
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
                self.rating.rac_newSelectedSegmentIndexChannelWithNilValue(UISegmentedControlNoSegment).toSignalProducer()
            |> map { ($0 as? Int)?.toRating() }
            |> start(next: { rating in
                self.logger.info("Save initiated")

                var dram = self.currentDram.value
                dram.rating = rating

                SignalProducer<Dram, NoError>(value: dram)
                    |> observeOn(QueueScheduler())
                    |> start(next: { self.repository.save($0) })
            })
    }
}
// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa
import UIKit


public final class NewDramController: UITableViewController {

    @IBOutlet
    public var date: UIDatePicker!

    @IBOutlet
    public var done: UIBarButtonItem!

    private let dram = MutableProperty<Dram>(Dram())

    @IBOutlet
    public var id: UITextField!

    private let logger = Logger()

    @IBOutlet
    public var rating: UISegmentedControl!

    public var repository = DramRepositoryManager.sharedInstance

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.date.maximumDate = NSDate()

        initDone()
        initDramUpdate()
        initSave()
    }
}

// MARK: - Done
extension NewDramController {
    private func initDone() {
        self.done.rac_command = toRACCommand(Action<AnyObject?, AnyObject?, NSError> { _ in
            self.logger.info("Done initiated")

            self.dismissViewControllerAnimated(true, completion: nil)
            return SignalProducer.empty
            })
    }
}

// MARK: - Dram Update
extension NewDramController {
    private func initDramUpdate() {
        self.date.rac_newDateChannelWithNilValue(NSDate()).toSignalProducer()
            |> map { $0 as? NSDate }
            |> start(next: { self.dram.value.date = $0 })

        self.id.rac_textSignal().toSignalProducer()
            |> map { $0 as? String  }
            |> start(next: { self.dram.value.id = $0 })

        self.rating.rac_newSelectedSegmentIndexChannelWithNilValue(UISegmentedControlNoSegment).toSignalProducer()
            |> map { ($0 as? Int)?.toRating() }
            |> start(next: { self.dram.value.rating = $0 })
    }
}

extension Int {
    public func toRating() -> Rating? {
        return Rating(rawValue: self)
    }
}

extension Dram {
    public func validDate() -> Bool {
        if let date = self.date {
            return date <= NSDate()
        } else {
            return false
        }
    }

    public func validId() -> Bool {
        if let id = self.id {
            return id =~ "^[\\d]{1,3}\\.[\\d]{1,3}$"
        } else {
            return false
        }
    }
}

// MARK: - Save
extension NewDramController {
    private func initSave() {
        self.dram.producer
            |> filter { $0.validId() && $0.validDate() }
            |> observeOn(QueueScheduler())
            |> start(next: {
                self.logger.info("Save initiated")
                self.repository.save($0)
            })
    }
}
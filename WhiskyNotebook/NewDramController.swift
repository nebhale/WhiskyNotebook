// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa
import UIKit


public final class NewDramController: UITableViewController {

    public var dram = MutableProperty<Dram>(Dram())

    @IBOutlet
    public var cancel: UIBarButtonItem!

    @IBOutlet
    public var date: UIDatePicker!

    @IBOutlet
    public var id: UITextField!

    private let logger = Logger()

    @IBOutlet
    public var rating: UISegmentedControl!

    public var repository = DramRepositoryManager.sharedInstance

    @IBOutlet
    public var save: UIBarButtonItem!

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.date.maximumDate = NSDate()

        initCancel()
        initDramUpdate()
        initSave()
        initSaveEnabled()
    }
}

// MARK: - Cancel
extension NewDramController {
    private func initCancel() {
        self.cancel.rac_command = toRACCommand(Action<AnyObject?, AnyObject?, NSError> { _ in
            self.logger.info("Cancel initiated")

            self.dismissViewControllerAnimated(true, completion: nil)
            return SignalProducer.empty
            })
    }
}

// MARK: - Dram Update
extension NewDramController {
    private func initDramUpdate() {
        self.dram.value.date = self.date.date
        self.date.rac_signalForControlEvents(.ValueChanged).toSignalProducer()
            |> map { ($0 as? UIDatePicker)?.date }
            |> start(next: { self.dram.value.date = $0 })

        self.dram.value.id = self.id.text
        self.id.rac_textSignal().toSignalProducer()
            |> map { $0 as? String  }
            |> start(next: { self.dram.value.id = $0 })

        self.dram.value.rating = self.rating.selectedSegmentIndex.toRating()
        self.rating.rac_signalForControlEvents(.ValueChanged).toSignalProducer()
            |> map { ($0 as? UISegmentedControl)?.selectedSegmentIndex.toRating() }
            |> start(next: { self.dram.value.rating = $0 })
    }
}

extension Int {
    public func toRating() -> Rating? {
        return Rating(rawValue: self)
    }
}

// MARK: - Interface Update
extension NewDramController {
    private func initSaveEnabled() {
        DynamicProperty(object: self.save, keyPath: "enabled") <~ self.dram.producer
            |> map { $0.validId() && $0.validDate() }
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
        self.save.rac_command = toRACCommand(Action<AnyObject?, AnyObject?, NSError> { _ in
            self.logger.info("Save initiated")

            SignalProducer<Dram, NoError>(value: self.dram.value)
                |> observeOn(QueueScheduler())
                |> start(next: { self.repository.save($0) })

            self.dismissViewControllerAnimated(true, completion: nil)
            return SignalProducer.empty
            })
    }
}
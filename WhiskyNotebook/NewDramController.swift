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

    public var repository = DramRepositoryManager.sharedInstance

    @IBOutlet
    public var save: UIBarButtonItem!
    private var saveEnabled: DynamicProperty!  // TODO: Remove pending https://github.com/ReactiveCocoa/ReactiveCocoa/issues/1855

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
        self.dram.value.id = self.id.text
        self.id.rac_textSignal().toSignalProducer()
            |> map { $0 as? String  }
            |> start(next: { self.dram.value.id = $0 })

        self.dram.value.date = self.date.date
        self.date.rac_signalForControlEvents(.ValueChanged).toSignalProducer()
            |> map { ($0 as? UIDatePicker)?.date }
            |> start(next: { self.dram.value.date = $0 })
    }
}

// MARK: - Interface Update
extension NewDramController {
    private func initSaveEnabled() {
        self.saveEnabled = DynamicProperty(object: self.save, keyPath: "enabled")
        self.saveEnabled <~ self.dram.producer
            |> map { $0.valid() }
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
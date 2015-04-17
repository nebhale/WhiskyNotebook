// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa
import UIKit


public final class NewDramController: UITableViewController {

    @IBOutlet
    public var date: UIDatePicker! {
        willSet(date) {
            date.maximumDate = NSDate()
        }
    }

    @IBOutlet
    public var id: UITextField!

    private let logger = Logger()

    @IBOutlet
    public var rating: UISegmentedControl!

    public var repository = DramRepositoryManager.sharedInstance

    @IBOutlet
    public var save: UIBarButtonItem!

    public var scheduler: SchedulerType = UIScheduler()

    override public func viewDidLoad() {
        super.viewDidLoad()

        initSaveEnabled()
    }
}

// MARK: - Cancel
extension NewDramController {

    @IBAction
    public func cancelAndDismiss() {
        self.logger.info("Cancel initiated")
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

// MARK: - Save
extension NewDramController {

    private func initSaveEnabled() {
        self.id.rac_textSignal().toSignalProducer()
            |> observeOn(self.scheduler)
            |> map { $0 as? String }
            |> start { self.save.enabled = $0?.validId() ?? false }
    }

    @IBAction
    public func saveAndDismiss() {
        self.logger.info("Save initiated")
        let dram = Dram(id: self.id.text, date: self.date.date, rating: Rating(rawValue: self.rating.selectedSegmentIndex))
        self.repository.save(dram)

        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

extension String {
    private func validId() -> Bool {
        return self =~ "^[\\d]{1,3}\\.[\\d]{1,3}$"
    }
}

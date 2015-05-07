// Copyright 2014-2015 Ben Hale. All Rights Reserved


import ReactiveCocoa
import UIKit

final class NewDramController: UITableViewController {

    @IBOutlet
    var date: UIDatePicker! {
        willSet(date) {
            date.maximumDate = NSDate()
        }
    }

    @IBOutlet
    var id: UITextField!

    @IBOutlet
    var rating: UISegmentedControl!

    @IBOutlet
    var save: UIBarButtonItem!

    var repository = DramRepositoryManager.sharedInstance

    var scheduler: SchedulerType = UIScheduler()

    override func viewDidLoad() {
        super.viewDidLoad()
        initSaveEnabled()
    }
}

// MARK: - Cancel
extension NewDramController {

    @IBAction
    func cancelAndDismiss() {
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
    func saveAndDismiss() {
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

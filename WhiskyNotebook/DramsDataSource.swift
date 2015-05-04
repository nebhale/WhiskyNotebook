// Copyright 2014-2015 Ben Hale. All Rights Reserved


import LoggerLogger
import ReactiveCocoa
import UIKit

final class DramsDataSource: NSObject, UITableViewDataSource {

    private let content: MutableProperty<[Dram]> = MutableProperty([])

    let drams: SignalProducer<[Dram], NoError>

    private let logger = Logger()

    var repository = DramRepositoryManager.sharedInstance

    var schedulerAsync: SchedulerType = QueueScheduler()

    var schedulerSync: SchedulerType = UIScheduler()

    override init() {
        self.drams = self.content.producer
    }

    func viewDidLoad() {
        initModelUpdate()
    }

}

// MARK: - Display Drams
extension DramsDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Dram", forIndexPath: indexPath) as! UITableViewCell

        if let cell = cell as? DramCell {
            cell.configure(content.value[indexPath.row])
        }

        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.value.count
    }

}

// MARK: - Edit Drams
extension DramsDataSource {

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.logger.info("Delete initiated")

        self.schedulerAsync.schedule {
            self.repository.delete(self.content.value[indexPath.row])
        }
    }

    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return tableView.editing ? .Delete : .None
    }
}

// MARK: - Model Update
extension DramsDataSource {
    private func initModelUpdate() {
        self.content <~ self.repository.drams
            |> observeOn(self.schedulerAsync)
            |> map { reverse(sorted($0, self.byDate)) }
            |> observeOn(self.schedulerSync)
    }

    private func byDate(x: Dram, y: Dram) -> Bool {
        return x.date < y.date
    }
}
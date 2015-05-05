// Copyright 2014-2015 Ben Hale. All Rights Reserved


import LoggerLogger
import ReactiveCocoa
import UIKit

final class DistilleriesDataSource: NSObject, UITableViewDataSource {

    private let content: MutableProperty<[Distillery]> = MutableProperty([])

    let distilleries: SignalProducer<[Distillery], NoError>

    private let logger = Logger()

    var repository = DistilleryRepositoryManager.sharedInstance

    var schedulerAsync: SchedulerType = QueueScheduler()

    var schedulerSync: SchedulerType = UIScheduler()

    override init() {
        self.distilleries = self.content.producer
    }

    func viewDidLoad() {
        initModelUpdate()
    }

}

// MARK: - Display Drams
extension DistilleriesDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Distillery", forIndexPath: indexPath) as! UITableViewCell

        if let cell = cell as? DistilleryCell {
            cell.configure(content.value[indexPath.row])
        }

        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.value.count
    }

}

// MARK: - Edit Drams
extension DistilleriesDataSource {

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
extension DistilleriesDataSource {
    private func initModelUpdate() {
        self.content <~ self.repository.distilleries
            |> observeOn(self.schedulerAsync)
            |> map { sorted($0, self.byRegionThenId) }
            |> observeOn(self.schedulerSync)
    }

    private func byRegionThenId(x: Distillery, y: Distillery) -> Bool {
        return x.rank() < y.rank()
    }
}

extension Distillery {
    private func rank() -> Int {
        return (self.id?.rank() ?? 0) + (self.region?.rank() ?? 0)
    }
}

extension Region {
    private func rank() -> Int {
        switch self {
        case .Grain:
            return 7000
        default:
            return 0
        }
    }
}

extension String {
    private func rank() -> Int {
        if let matches = self.matches("^[A-Z]?([\\d]+)$") {
            let range = matches[0].rangeAtIndex(1)
            if let digits = self[range.location..<(range.location + range.length)] {
                return digits.toInt() ?? 0
            }
        }

        return 0
    }
}
// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa
import UIKit


public final class DistilleriesDataSource: NSObject, UITableViewDataSource {

    private let content: MutableProperty<[Distillery]> = MutableProperty([])

    public let distilleries: SignalProducer<[Distillery], NoError>

    private let logger = Logger()

    public var repository = DistilleryRepositoryManager.sharedInstance

    public var scheduler: SchedulerType = QueueScheduler()

    override public init() {
        self.distilleries = self.content.producer
    }

    public func viewDidLoad() {
        initModelUpdate()
    }

}

// MARK: - Display Drams
extension DistilleriesDataSource {

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Distillery", forIndexPath: indexPath) as! UITableViewCell

        if let cell = cell as? DistilleryCell {
            cell.configure(content.value[indexPath.row])
        }

        return cell
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.value.count
    }

}

// MARK: - Edit Drams
extension DistilleriesDataSource {

    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.logger.info("Delete initiated")

        self.scheduler.schedule {
            self.repository.delete(self.content.value[indexPath.row])
        }
    }

    public func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return tableView.editing ? .Delete : .None
    }
}

// MARK: - Model Update
extension DistilleriesDataSource {
    private func initModelUpdate() {
        self.content <~ self.repository.distilleries
            |> observeOn(self.scheduler)
            |> map { sorted($0, self.byRegionThenId) }
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
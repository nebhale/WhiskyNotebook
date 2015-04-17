// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa
import UIKit


public final class DramsDataSource: NSObject, UITableViewDataSource {

    private let content: MutableProperty<[Dram]> = MutableProperty([])

    public let drams: SignalProducer<[Dram], NoError>

    private let logger = Logger()

    public var repository = DramRepositoryManager.sharedInstance

    public var scheduler: SchedulerType = QueueScheduler()

    override public init() {
        self.drams = self.content.producer
    }

    public func viewDidLoad() {
        initModelUpdate()
    }

}

// MARK: - Display Drams
extension DramsDataSource {

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Dram", forIndexPath: indexPath) as! UITableViewCell

        if let cell = cell as? DramCell {
            cell.configure(content.value[indexPath.row])
        }

        return cell
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.value.count
    }

}

// MARK: - Edit Drams
extension DramsDataSource {

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
extension DramsDataSource {
    private func initModelUpdate() {
        self.content <~ self.repository.drams
            |> map { reverse(sorted($0, self.byDate)) }
    }

    private func byDate(x: Dram, y: Dram) -> Bool {
        return x.date < y.date
    }
}
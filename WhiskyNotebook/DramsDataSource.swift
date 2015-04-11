// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa
import UIKit


public final class DramsDataSource: NSObject, UITableViewDataSource {

    public let currentDrams: MutableProperty<[Dram]> = MutableProperty([])

    private let logger = Logger()

    public var repository = DramRepositoryManager.sharedInstance

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
            cell.currentDram.value = currentDrams.value[indexPath.row]
        }

        return cell
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentDrams.value.count
    }

}

// MARK: - Edit Drams
extension DramsDataSource {

    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.logger.info("Delete initiated")

        SignalProducer<Dram, NoError>(value: self.currentDrams.value[indexPath.row])
            |> observeOn(QueueScheduler())
            |> start(next: { self.repository.delete($0)} )
    }

    public func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return tableView.editing ? .Delete : .None
    }
}

// MARK: - Model Update
extension DramsDataSource {
    private func initModelUpdate() {
        self.currentDrams <~ self.repository.currentDrams.producer
            |> map { sorted($0, self.reverseChronological) }
    }

    private func reverseChronological(x: Dram, y: Dram) -> Bool {
        return x.date > y.date
    }
}
// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa
import UIKit


public final class DramsController: UITableViewController {

    private var drams: [Dram] = []

    private let (editingStateSignal, editingStateSink) = Signal<EditingState, NoError>.pipe()

    private let logger = Logger()

    public var repository = DramRepositoryManager.sharedInstance

    public override func viewDidLoad() {
        super.viewDidLoad()

        initModelUpdate()
        initNavigationBarContents()
    }
}

// MARK: - Display Drams
extension DramsController {

    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Dram", forIndexPath: indexPath) as! UITableViewCell

        if let cell = cell as? DramCell {
            cell.dram.value = drams[indexPath.row]
        }

        return cell
    }

    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.drams.count
    }
}

// MARK: - Edit Drams
extension DramsController {

    override public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.logger.info("Delete initiated")

        SignalProducer<Dram, NoError>(value: self.drams[indexPath.row])
            |> observeOn(QueueScheduler())
            |> start(next: { self.repository.delete($0)} )
    }

    override public func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return tableView.editing ? .Delete : .None
    }
}

// MARK: - Interface Update
extension DramsController {

    private func initNavigationBarContents() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        let addButton = self.navigationItem.rightBarButtonItem

        self.editingStateSignal
            |> observe(next: { editingState in
                switch(editingState) {
                case .Editing:
                    self.navigationItem.setRightBarButtonItem(nil, animated: true)
                case .NotEditing:
                    self.navigationItem.setRightBarButtonItem(addButton, animated: true)
                }
            })
    }

    override public func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        sendNext(self.editingStateSink, editing ? .Editing : .NotEditing)
    }
}

// MARK: - Model Update
extension DramsController {
    private func initModelUpdate() {
        self.repository.drams.producer
            |> map { Delta(old: self.drams, new: $0) }
            |> observeOn(UIScheduler())
            |> start(next: { delta in
                self.drams = delta.new
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths(self.toIndexPaths(delta.deleted, section: 0), withRowAnimation: .Automatic)
                self.tableView.reloadRowsAtIndexPaths(self.toIndexPaths(delta.modified, section: 0), withRowAnimation: .Automatic)
                self.tableView.insertRowsAtIndexPaths(self.toIndexPaths(delta.added, section: 0), withRowAnimation: .Automatic)
                self.tableView.endUpdates()
            })
    }

    private func toIndexPaths(rows: [Int], section: Int) -> [NSIndexPath] {
        return rows.map { NSIndexPath(forRow: $0, inSection: section) }
    }
}

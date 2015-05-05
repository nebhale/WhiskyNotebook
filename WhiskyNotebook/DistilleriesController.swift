// Copyright 2014-2015 Ben Hale. All Rights Reserved


import ReactiveCocoa
import UIKit

final class DistilleriesController: UITableViewController {

    @IBOutlet
    var add: UIBarButtonItem!

    private let (editingState, sink) = Signal<EditingState, NoError>.pipe()

    @IBOutlet
    var dataSource: DistilleriesDataSource!
    
    var scheduler: SchedulerType = UIScheduler()

    override func viewDidLoad() {
        super.viewDidLoad()

        initModelUpdate()
        initNavigationBarContents()
    }
}

// MARK: - Interface Update
extension DistilleriesController {
    private func initNavigationBarContents() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        self.editingState
            |> observe { editingState in
                switch(editingState) {
                case .Editing:
                    self.navigationController?.setToolbarHidden(false, animated: true)
                    self.navigationItem.setRightBarButtonItem(nil, animated: true)
                case .NotEditing:
                    self.navigationController?.setToolbarHidden(true, animated: true)
                    self.navigationItem.setRightBarButtonItem(self.add, animated: true)
                }
        }
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        sendNext(sink, editing ? .Editing : .NotEditing)
    }
}

// MARK: - Model Update
extension DistilleriesController {
    private func initModelUpdate() {
        self.dataSource.viewDidLoad()
        self.dataSource.distilleries
            |> combinePrevious([])
            |> map { Delta(old: $0, new: $1, contentMatches: self.contentMatches) }
            |> observeOn(self.scheduler)
            |> start { delta in
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths(self.toIndexPaths(delta.deleted, section: 0), withRowAnimation: .Automatic)
                self.tableView.reloadRowsAtIndexPaths(self.toIndexPaths(delta.modified, section: 0), withRowAnimation: .Automatic)
                self.tableView.insertRowsAtIndexPaths(self.toIndexPaths(delta.added, section: 0), withRowAnimation: .Automatic)
                self.tableView.endUpdates()
        }
    }

    private func contentMatches(x: Distillery, y: Distillery) -> Bool {
        return x.id == y.id && x.name == y.name && x.region == y.region
    }

    private func toIndexPaths(rows: [Int], section: Int) -> [NSIndexPath] {
        return rows.map { NSIndexPath(forRow: $0, inSection: section) }
    }
}
// Copyright 2014-2015 Ben Hale. All Rights Reserved


import ReactiveCocoa
import UIKit

final class DistilleriesController: UITableViewController {

    @IBOutlet
    var add: UIBarButtonItem!

    var dataSource: DistilleryDataSource = ArrayDistilleryDataSource()

    var scheduler: SchedulerType = UIScheduler()

    private let (editingState, sink) = Signal<EditingState, NoError>.pipe()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self.dataSource

        initModelUpdate()
        initNavigationBarContents()
    }
}

// MARK: - Import/Export
extension DistilleriesController {

    @IBAction
    func importDistilleries() {
        DistilleryCSVImporter(viewController: self).importDistilleries()
    }

    @IBAction
    func exportDistilleries() {
        DistilleryCSVExporter(viewController: self).exportDistilleries()
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
        self.dataSource.distilleries.producer
            |> observeOn(self.scheduler)
            |> combinePrevious([])
            |> map { Delta(old: $0, new: $1, contentMatches: self.contentMatches) }
            |> start { delta in
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths(toIndexPaths(delta.deleted), withRowAnimation: .Automatic)
                self.tableView.reloadRowsAtIndexPaths(toIndexPaths(delta.modified), withRowAnimation: .Automatic)
                self.tableView.insertRowsAtIndexPaths(toIndexPaths(delta.added), withRowAnimation: .Automatic)
                self.tableView.endUpdates()
        }
    }

    private func contentMatches(x: Distillery, y: Distillery) -> Bool {
        return x.id == y.id && x.name == y.name && x.region == y.region
    }
}
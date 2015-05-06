// Copyright 2014-2015 Ben Hale. All Rights Reserved


import ReactiveCocoa
import UIKit

final class DramsController: UITableViewController {

    @IBOutlet
    var add: UIBarButtonItem!

    var dataSource: DramDataSource = ArrayDramDataSource()

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
extension DramsController {

    @IBAction
    func importDrams() {
        DramCSVImporter(viewController: self).importDrams()
    }

    @IBAction
    func exportDrams() {
        DramCSVExporter(viewController: self).exportDrams()
    }
}

// MARK: - Interface Update
extension DramsController {

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
extension DramsController {

    private func initModelUpdate() {
        self.dataSource.drams.producer
            |> combinePrevious([])
            |> observeOn(self.scheduler)
            |> map { Delta(old: $0, new: $1, contentMatches: self.contentMatches) }
            |> start { delta in
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths(toIndexPaths(delta.deleted), withRowAnimation: .Automatic)
                self.tableView.reloadRowsAtIndexPaths(toIndexPaths(delta.modified), withRowAnimation: .Automatic)
                self.tableView.insertRowsAtIndexPaths(toIndexPaths(delta.added), withRowAnimation: .Automatic)
                self.tableView.endUpdates()
        }
    }

    private func contentMatches(x: Dram, y: Dram) -> Bool {
        return x.id == y.id && x.date == y.date && x.rating == y.rating
    }
}
// Copyright 2014-2015 Ben Hale. All Rights Reserved


import ReactiveCocoa
import UIKit

final class ArrayDramDataSource: NSObject, DramDataSource {

    let drams: PropertyOf<[Dram]>

    private let delegate: ArrayDataSource<Dram>

    init(repository: DramRepository, scheduler: SchedulerType) {
        let arrayProducer = repository.drams.producer
            |> map { sorted($0, ArrayDramDataSource.isOrderedBefore) }

        self.delegate = ArrayDataSource(
            arrayProducer: arrayProducer,
            cellIdentifier: "Dram",
            configureCell: ArrayDramDataSource.configureCell,
            deleteItem: ArrayDramDataSource.deleteItem(repository),
            scheduler: scheduler
        )
        self.drams = self.delegate.items
    }

    override convenience init() {
        self.init(repository: DramRepositoryManager.sharedInstance, scheduler: QueueScheduler())
    }

    // MARK: - Display
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.delegate.numberOfSectionsInTableView(tableView)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.delegate.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.delegate.tableView(tableView, numberOfRowsInSection: section)
    }

    // MARK: - Edit
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.delegate.tableView(tableView, canEditRowAtIndexPath: indexPath)
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate.tableView(tableView, commitEditingStyle: editingStyle, forRowAtIndexPath: indexPath)
    }

    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return self.delegate.tableView(tableView, editingStyleForRowAtIndexPath: indexPath)
    }

    private static func configureCell(cell: UITableViewCell, dram: Dram) {
        if let cell = cell as? DramCell {
            cell.configure(dram)
        }
    }

    // MARK: -
    private static func deleteItem(repository: DramRepository)(dram: Dram) {
        repository.delete(dram)
    }

    private static func isOrderedBefore(x: Dram, y: Dram) -> Bool {
        return x.date > y.date
    }
    
}

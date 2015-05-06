// Copyright 2014-2015 Ben Hale. All Rights Reserved


import ReactiveCocoa
import UIKit

final class ArrayDistilleryDataSource: NSObject, DistilleryDataSource {

    let distilleries: PropertyOf<[Distillery]>

    private let delegate: ArrayDataSource<Distillery>

    override convenience init() {
        self.init(repository: DistilleryRepositoryManager.sharedInstance, scheduler: QueueScheduler())
    }

    init(repository: DistilleryRepository, scheduler: SchedulerType) {
        let arrayProducer = repository.distilleries.producer
            |> map { sorted($0, ArrayDistilleryDataSource.isOrderedBefore) }

        self.delegate = ArrayDataSource(
            arrayProducer: arrayProducer,
            cellIdentifier: "Distillery",
            configureCell: ArrayDistilleryDataSource.configureCell,
            deleteItem: ArrayDistilleryDataSource.deleteItem(repository),
            scheduler: scheduler
        )

        self.distilleries = self.delegate.items
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

    private static func configureCell(cell: UITableViewCell, distillery: Distillery) {
        if let cell = cell as? DistilleryCell {
            cell.configure(distillery)
        }
    }

    // MARK: -
    private static func deleteItem(repository: DistilleryRepository)(distillery: Distillery) {
        repository.delete(distillery)
    }

    private static func isOrderedBefore(x: Distillery, y: Distillery) -> Bool {
        return x.rank < y.rank
    }
}

extension Distillery {
    private var rank: Int {
        return (self.id?.rank ?? 0) + (self.region?.rank ?? 0)
    }
}

extension Region {
    private var rank: Int {
        switch self {
        case .Grain:
            return 7000
        default:
            return 0
        }
    }
}

extension String {
    private var rank: Int {
        if let matches = self.matches("^[A-Z]?([\\d]+)$") {
            let range = matches[0].rangeAtIndex(1)
            if let digits = self[range.location..<(range.location + range.length)] {
                return digits.toInt() ?? 0
            }
        }

        return 0
    }
}

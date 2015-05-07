// Copyright 2014-2015 Ben Hale. All Rights Reserved


import ReactiveCocoa
import UIKit

final class ArrayDataSource<T> {

    typealias ConfigureCell = (UITableViewCell, T) -> Void

    typealias DeleteItem = (T) -> Void

    let items: PropertyOf<[T]>

    private let _items: MutableProperty<[T]>

    private let cellIdentifier: String

    private let configureCell: ConfigureCell

    private let deleteItem: DeleteItem

    private let scheduler: SchedulerType

    init(arrayProducer: SignalProducer<[T], NoError>, cellIdentifier: String, configureCell: ConfigureCell, deleteItem: DeleteItem, scheduler: SchedulerType) {
        self._items = MutableProperty([])
        self._items <~ arrayProducer
            |> observeOn(scheduler)

        self.cellIdentifier = cellIdentifier
        self.configureCell = configureCell
        self.deleteItem = deleteItem
        self.items = PropertyOf(self._items)
        self.scheduler = scheduler
    }

    // MARK: - Display
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let item = self._items.value[indexPath.row]

        self.configureCell(cell, item)

        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._items.value.count
    }

    // MARK: - Edit
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.scheduler.schedule {
            let item = self._items.value[indexPath.row]
            self.deleteItem(item)
        }
    }

    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return tableView.editing ? .Delete : .None
    }
    
}
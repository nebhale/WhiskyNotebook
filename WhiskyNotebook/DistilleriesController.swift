// Copyright 2014-2015 Ben Hale. All Rights Reserved

import UIKit


final class DistilleriesController: UITableViewController, UIDocumentPickerDelegate, UISearchResultsUpdating {

    private let logger = Logger(name: "DistilleriesController")

    private var addButton: UIBarButtonItem?

    var distilleries: [Distillery]? = [] {
        didSet {
            onMain { self.tableView.reloadData() }
        }
    }

    var distilleryRepositoryMemento: Memento?

    private var importButton: UIBarButtonItem?

    private var importedDistilleries: [Distillery] = []

    private var searchController = UISearchController(searchResultsController: nil)

    private var searchDistilleries: [Distillery]?

    var user: User? {
        didSet {
            onMain {
                self.navigationItem.rightBarButtonItem = (self.user?.administrator == true) ? self.addButton : nil
                self.navigationItem.leftBarButtonItem = (self.user?.administrator == true) ? self.importButton : nil
                self.tableView.reloadData()
            }
        }
    }

    var userRepositoryMemento: Memento?

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        DistilleryRepository.instance.unsubscribe(self.distilleryRepositoryMemento)
        UserRepository.instance.unsubscribe(self.userRepositoryMemento)
    }

    @IBAction
    func distilleryAddCancel(segue: UIStoryboardSegue) {
        if let sourceViewController = segue.sourceViewController as? DistilleryAddController {
            sourceViewController.dismissViewControllerAnimated(true) {
                self.importedDistilleries.removeAll(keepCapacity: false)
            }
        }
    }

    @IBAction
    func distilleryAddSave(segue: UIStoryboardSegue) {
        if let sourceViewController = segue.sourceViewController as? DistilleryAddController {
            sourceViewController.dismissViewControllerAnimated(true) {
                if let addDataController = sourceViewController.childViewControllers.first as? DistilleryAddDataController {
                    DistilleryRepository.instance.save(addDataController.toDistillery())
                    self.processImportedDistilleries()
                }
            }
        }
    }

    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        var error: NSError?
        let contents = String(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: &error)

        if error != nil {
            // TODO: Handle error reading imported file
            self.logger.error { "Error reading imported file: \(error)" }
            return
        }

        if let contents = contents {
            for line in contents.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).componentsSeparatedByString("\n") {
                self.importedDistilleries.append(Distillery(data: line.componentsSeparatedByString(",")))
            }
        }

        processImportedDistilleries()
    }

    @IBAction
    func importDistilleries() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.comma-separated-values-text"], inMode: UIDocumentPickerMode.Import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.FormSheet

        self.presentViewController(documentPicker, animated: true, completion: nil)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDistillery" {
            if let row = self.tableView.indexPathForSelectedRow()?.row {
                if let controller = segue.destinationViewController as? DistilleryController {
                    controller.distillery = resolvedDistilleries()?[row]
                }
            }
            self.searchController.active = false
        } else if segue.identifier == "AddDistillery" && !self.importedDistilleries.isEmpty {
            if let controller = segue.destinationViewController as? DistilleryAddController {
                controller.importedDistillery = self.importedDistilleries.removeAtIndex(0)
            }
        }
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.user?.administrator == true
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Distillery", forIndexPath: indexPath) as! UITableViewCell

        if let distilleryCell = cell as? DistilleryCell {
            distilleryCell.accessoryView = nil
            distilleryCell.loadItem(resolvedDistilleries()?[indexPath.row])
        }

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if UITableViewCellEditingStyle.Delete == editingStyle {
            DistilleryRepository.instance.delete(resolvedDistilleries()?[indexPath.row])

            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                activityIndicator.startAnimating()
                cell.accessoryView = activityIndicator
            }

            tableView.setEditing(false, animated: true)
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let distilleries = resolvedDistilleries() {
            return distilleries.count
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let query = searchController.searchBar.text
        self.searchDistilleries = self.distilleries?.filter { distillery in
            if query.isEmpty {
                return true
            }

            if let id = distillery.id {
                if id.containsIgnoreCase(query) {
                    return true
                }
            }

            if let name = distillery.name {
                if name.containsIgnoreCase(query) {
                    return true
                }
            }

            if let region = distillery.region {
                if region.containsIgnoreCase(query) {
                    return true
                }
            }

            return false
        }

        onMain { self.tableView.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.distilleryRepositoryMemento = DistilleryRepository.instance.subscribe { self.distilleries = $0 }
        self.userRepositoryMemento = UserRepository.instance.subscribe { self.user = $0 }

        self.addButton = self.navigationItem.rightBarButtonItem
        self.navigationItem.rightBarButtonItem = nil

        self.importButton = self.navigationItem.leftBarButtonItem
        self.navigationItem.leftBarButtonItem = nil

        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self

        let searchBar = self.searchController.searchBar
        searchBar.searchBarStyle = .Minimal
        searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchBar
    }

    private func resolvedDistilleries() -> [Distillery]? {
        if self.searchController.active {
            return self.searchDistilleries
        } else {
            return self.distilleries
        }
    }

    private func processImportedDistilleries() {
        if !self.importedDistilleries.isEmpty {
            onMain { self.performSegueWithIdentifier("AddDistillery", sender: self) }
        }
    }

}

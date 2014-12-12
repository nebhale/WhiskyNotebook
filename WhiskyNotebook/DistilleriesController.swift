// Copyright 2014 Ben Hale. All Rights Reserved

import UIKit

final class DistilleriesController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet
    var tableView: UITableView!
    
    let distilleries = Distilleries()
    
    var filteredDistilleries = Distilleries()
    
    let logger = Logger(name: "DistilleriesTableViewController")
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.distilleries.update() {
            self.logger.info { return "Update complete" }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                
                self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController!.searchBar.frame.size.height);
                self.tableView.hidden = false
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return getDistilleries(tableView).count()
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredDistilleries = self.distilleries.filter { distillery in
            return distillery.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil
        }
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return getDistilleries(tableView).map { distillery in
            return distillery.id
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("distillery") as DistilleryCell
        cell.loadItem(getDistilleries(tableView)[indexPath.section])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    private func getDistilleries(tableView: UITableView) -> Distilleries {
        return tableView == self.searchDisplayController!.searchResultsTableView ? self.filteredDistilleries : self.distilleries
    }
    
}

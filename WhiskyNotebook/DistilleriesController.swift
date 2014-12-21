// Copyright 2014 Ben Hale. All Rights Reserved

import UIKit

final class DistilleriesController: UITableViewController {
    
    // MARK: Properties
    
    private var filteredProjection: Projection?
    
    private let logger = Logger("DistilleriesController")
    
    private var projection: Projection?
    
    // MARK: UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.logger.debug { "Search text changed to '\(searchText)'" }
        
        if let projection = self.projection {
            self.filteredProjection = FilteredProjection(projection.source(), searchText)
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.filteredProjection = nil
        
        onMain {
            self.tableView.reloadData()
        }
    }
    
    // MARK: UISearchDisplayDelegate
    
    func searchDisplayController(controller: UISearchDisplayController, willShowSearchResultsTableView tableView: UITableView) {
        tableView.rowHeight = self.tableView.rowHeight
    }
    
    // MARK: UITableView
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let projection = self.filteredProjection {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("distillery") as DistilleryCell
            cell.loadItem(projection.at(indexPath.row))
            return cell
        } else if let projection = self.projection {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("distillery", forIndexPath: indexPath) as DistilleryCell
            cell.loadItem(projection.at(indexPath.row))
            return cell
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let projection = self.filteredProjection {
            return projection.count()
        } else if let projection = self.projection {
            return projection.count()
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDistillery" {
            self.logger.debug { "Handling showDistillery segue" }
            
            var distillery: Distillery?
            if let projection = self.filteredProjection {
                if let row = self.searchDisplayController?.searchResultsTableView.indexPathForSelectedRow()?.row {
                    distillery = projection.at(row)
                }
            } else if let projection = self.projection {
                if let row = self.tableView.indexPathForSelectedRow()?.row {
                    distillery = projection.at(row)
                }
            }
            
            (segue.destinationViewController as DistilleryController).distillery = distillery
        } else {
            self.logger.debug { "Discarding segue \(segue)" }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Remove in next version of iOS
        self.tableView.rowHeight = 48.0
        
        DistilleriesFactory().create { distilleries in
            self.logger.info { "Distilleries creation complete" }
            self.projection = StandardProjection(distilleries.sorted { $0 < $1 })
            
            onMain {
                self.hideSearchBar()
                self.tableView.tableHeaderView?.hidden = false
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                self.tableView.reloadData()
            }
        }
    }
    
    private func hideSearchBar() {
        self.logger.debug { "Hiding SearchBar" }
        
        if let searchBar = self.searchDisplayController?.searchBar {
            self.tableView.contentOffset.y = min(0, searchBar.frame.size.height - self.tableView.contentInset.top)
        }
    }
    
}

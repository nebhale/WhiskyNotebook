// Copyright 2014 Ben Hale. All Rights Reserved

import UIKit

final class DistilleriesController: UITableViewController {
    
    private let logger = Logger("DistilleriesController")
    
    private var projection: Projection?
    
    private var filteredProjection: Projection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    // Table View
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let projection = projection(tableView) {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("distillery") as DistilleryCell
            cell.loadItem(projection.at(indexPath.row))
            return cell
        }
        
        let defaultValue = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        self.logger.debug { "Using default cellForRowAtIndexPath" }
        return defaultValue
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let projection = projection(tableView) {
            return projection.count()
        }
        
        let defaultValue = super.tableView(tableView, numberOfRowsInSection: section)
        self.logger.debug { "Using default numberOfRowsInSection \(defaultValue)" }
        return defaultValue
    }
    
    private func projection(tableView: UITableView) -> Projection? {
        return self.filteredProjection != nil ? self.filteredProjection : self.projection
    }
    
    // Search Bar
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.logger.debug { "Search text changed to '\(searchText)'" }
        
        if let projection = self.projection {
            self.filteredProjection = FilteredProjection(projection.source(), searchText)
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.filteredProjection = nil
    }
    
    private func hideSearchBar() {
        self.logger.debug { "Hiding SearchBar" }
        
        if let searchBar = self.searchDisplayController?.searchBar {
            self.tableView.contentOffset.y = min(0, searchBar.frame.size.height - self.tableView.contentInset.top)
        }
    }
    
}

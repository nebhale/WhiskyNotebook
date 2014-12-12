// Copyright 2014 Ben Hale. All Rights Reserved

import UIKit

final class DistilleriesController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let logger = Logger("DistilleriesTableViewController")
    
    @IBOutlet
    var tableView: UITableView!
    
    @IBOutlet
    var segmentedControl: UISegmentedControl!
    
    private var sectionProjection: SectionProjection?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        DistilleriesFactory().create { distilleries in
            self.logger.info { return "Distilleries creation complete" }
            
            switch self.segmentedControl.selectedSegmentIndex {
            case 0:
                self.sectionProjection = NumberSectionProjection<Void>(distilleries)
            case 1:
                self.sectionProjection = NameSectionProjection<Void>(distilleries)
            case 2:
                self.sectionProjection = RegionSectionProjection<Void>(distilleries)
            default:
                self.logger.error { "Unknown segment index selected" }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                
                // self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController!.searchBar.frame.size.height);
                self.tableView.hidden = false
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sectionProjection = self.sectionProjection {
            return sectionProjection.sectionCount()
        } else {
            return 0
        }
    }
    
    @IBAction
    func projectionChanged(segmentedControl: UISegmentedControl) {
        if let sectionProjection = self.sectionProjection {
            switch self.segmentedControl.selectedSegmentIndex {
            case 0:
                self.sectionProjection = NumberSectionProjection<Void>(sectionProjection)
            case 1:
                self.sectionProjection = NameSectionProjection<Void>(sectionProjection)
            case 2:
                self.sectionProjection = RegionSectionProjection<Void>(sectionProjection)
            default:
                self.logger.error { "Unknown segment index selected" }
            }
            
            self.tableView.reloadData()
        }
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        if let sectionProjection = self.sectionProjection {
            return sectionProjection.sectionIndexTitles()
        } else {
            return []
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("distillery") as DistilleryCell
        
        if let sectionProjection = self.sectionProjection {
            cell.loadItem(sectionProjection.at(indexPath))
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionProjection = self.sectionProjection {
            return sectionProjection.distilleryCount(section)
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionProjection?.sectionTitle(section)
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if let sectionProjection = self.sectionProjection {
            self.sectionProjection = FilteredSectionProjection(sectionProjection) { distillery in
                return distillery.name.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil
            }
        }
    }
    
}

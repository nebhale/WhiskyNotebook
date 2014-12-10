// Copyright 2014 Ben Hale. All Rights Reserved

import UIKit

final class DistilleriesController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet
    var tableView: UITableView!
    
    let distilleries = Distilleries()
    
    let logger = Logger(name: "DistilleriesTableViewController")
    
    override func viewWillAppear(animated: Bool) {
        self.distilleries.update() {
            self.logger.info { return "Update complete" }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.distilleries.count()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("distillery") as DistilleryCell
        cell.loadItem(self.distilleries[indexPath.row])        
        return cell
    }
    
}

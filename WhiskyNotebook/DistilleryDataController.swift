// Copyright 2014-2015 Ben Hale. All Rights Reserved

import UIKit


final class DistilleryDataController: UITableViewController {
    
    @IBOutlet
    var region: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 44
    }
    
}
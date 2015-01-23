// Copyright 2014-2015 Ben Hale. All Rights Reserved

import UIKit

final class ProfileEditDataController: UITableViewController {
    
    private let logger = Logger(name: "ProfileEditDataController")
    
    @IBOutlet
    var membership: UITextField?
    
    @IBOutlet
    var name: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Segued View calculates a non-standard row height
        self.tableView.rowHeight = 44
    }
    
}
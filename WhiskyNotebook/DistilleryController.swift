// Copyright 2014 Ben Hale. All Rights Reserved

import UIKit

final class DistilleryController: UIViewController {
    
    // MARK: Properties
    
    var distillery: Distillery?
    
    private let logger = Logger("DistilleryController")
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = self.distillery?.name
    }
    
}

// Copyright 2014 Ben Hale. All Rights Reserved

import UIKit

final class RootController: UITabBarController {
    
    // MARK: UIViewController
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: Remove once there's a real Drams implementation
        self.selectedViewController = self.viewControllers?[1] as? UIViewController
    }
    
}
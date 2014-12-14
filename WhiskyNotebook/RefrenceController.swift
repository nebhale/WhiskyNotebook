// Copyright 2014 Ben Hale. All Rights Reserved

import UIKit

final class ReferenceController: UITabBarController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: Remove once there's a real log
        self.selectedViewController = self.viewControllers?[1] as? UIViewController
    }
    
}
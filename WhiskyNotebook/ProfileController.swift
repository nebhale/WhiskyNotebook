// Copyright 2014-2015 Ben Hale. All Rights Reserved

import UIKit

final class ProfileController: UIViewController, UIBarPositioningDelegate {
    
    private let logger = Logger(name: "ProfileController")
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }

    @IBAction
    func profileEditCancel(segue: UIStoryboardSegue) {
        self.logger.debug { "Profile edit canceled" }
    }
    
    @IBAction
    func profileEditSave(segue: UIStoryboardSegue) {
        self.logger.debug { "Profile edit saved" }
    }
    
}
// Copyright 2014-2015 Ben Hale. All Rights Reserved

import UIKit


final class ProfileEditController: UIViewController, UIBarPositioningDelegate {

    private let logger = Logger(name: "ProfileEditController")

    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }

}

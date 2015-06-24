// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import CloudKit
import LoggerLogger
import ReactiveCocoa
import UIKit


final class ICloudEnforcer {

    private let logger = Logger()

    private let application: UIApplication

    // MARK: -

    init(application: UIApplication) {
        self.application = application
    }

    // MARK: -

    func enforceAccountAvailable() {
        accountStatus()
            .observeOn(UIScheduler())
            .observe(
                error: { self.logger.error("Error \($0)") },
                next: { status in
                    switch status {
                    case .CouldNotDetermine, .Restricted:
                        self.logger.warn("Unable to determine if iCloud account available")
                        self.presentAlert("Ambiguous iCloud Account", message: "You experience may be degraded")
                    case .NoAccount:
                        self.logger.warn("iCloud account not available")
                        self.presentAlert("Missing iCloud Account", message: "You experience will be degraded")
                    case .Available:
                        self.logger.debug("iCloud account available")
                    }
                }
        )
    }

    // MARK: -

    private func presentAlert(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))

        self.application.keyWindow?.rootViewController?.presentViewController(controller, animated: true, completion: nil)
    }
}
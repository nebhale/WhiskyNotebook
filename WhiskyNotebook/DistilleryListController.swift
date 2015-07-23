// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import LoggerLogger
import ReactiveCocoa
import UIKit


final class DistilleryListController: UITableViewController {

    private var distilleryRepository: DistilleryRepository!

    private let logger = Logger()

    // MARK: -

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier {
        case .Some("DistilleryDetails"):
            if let viewController = segue.destinationViewController as? DistilleryDetailsController, let selectedDistillery = self.tableView.indexPathForSelectedRow?.row {
                viewController.configureWithDistillery(self.distilleryRepository.distilleries.value[selectedDistillery])
            }
        default:
            self.logger.warn("Unknown segue \(segue.identifier)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.distilleryRepository == nil {
            self.distilleryRepository = ApplicationContext.sharedInstance.distilleryRepository()
        }

        if self.tableView.dataSource === self {
            self.tableView.dataSource = ApplicationContext.sharedInstance.distilleryDataSource()
        }

        self.self.distilleryRepository.distilleries.producer
            .observeOn(UIScheduler())
            .start { _ in self.tableView.reloadData() }
    }
}
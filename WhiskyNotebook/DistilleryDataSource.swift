// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import UIKit
import ReactiveCocoa


final class DistilleryDataSource: NSObject, UITableViewDataSource {

    private let distilleryRepository: DistilleryRepository

    // MARK: -

    init(distilleryRepository: DistilleryRepository) {
        self.distilleryRepository = distilleryRepository
    }

    // MARK: -

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.distilleryRepository.distilleries.value.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Distillery") as! DistilleryCell
        cell.configureWithDistillery(self.distilleryRepository.distilleries.value[indexPath.row])
        return cell
    }
}
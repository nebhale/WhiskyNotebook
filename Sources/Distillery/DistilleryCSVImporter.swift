// Copyright 2014-2015 Ben Hale. All Rights Reserved


import ReactiveCocoa
import UIKit

final class DistilleryCSVImporter: NSObject {

    private let delegate: CSVImporter<Distillery>

    init(repository: DistilleryRepository, scheduler: SchedulerType, viewController: UIViewController) {
        self.delegate = CSVImporter(
            saveItem: DistilleryCSVImporter.saveItem(repository),
            scheduler: scheduler,
            transformItem: DistilleryCSVImporter.transformItem(),
            type: "Distillery",
            viewController: viewController
        )
    }

    convenience init(viewController: UIViewController) {
        self.init(repository: DistilleryRepositoryManager.sharedInstance, scheduler: QueueScheduler(), viewController: viewController)
    }

    func importDistilleries() {
        self.delegate.importItems()
    }

    // MARK: -
    private static func saveItem(repository: DistilleryRepository) -> Distillery -> Void {
        return { repository.save($0) }
    }

    private static func transformItem() -> [String] -> Distillery {
        return { components in
            let location = locationFrom(components[3], components[4])
            return Distillery(id: components[0], location: location, name: components[1], region: Region(rawValue: components[2]))
        }
    }
}
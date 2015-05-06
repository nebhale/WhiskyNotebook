// Copyright 2014-2015 Ben Hale. All Rights Reserved


import ReactiveCocoa
import UIKit

final class DramCSVImporter: NSObject {

    private let delegate: CSVImporter<Dram>

    init(repository: DramRepository, scheduler: SchedulerType, viewController: UIViewController) {
        self.delegate = CSVImporter(
            saveItem: DramCSVImporter.saveItem(repository),
            scheduler: scheduler,
            transformItem: DramCSVImporter.transformItem(),
            type: "Dram",
            viewController: viewController
        )
    }

    convenience init(viewController: UIViewController) {
        self.init(repository: DramRepositoryManager.sharedInstance, scheduler: QueueScheduler(), viewController: viewController)
    }

    func importDrams() {
        self.delegate.importItems()
    }

    // MARK: -
    private static func saveItem(repository: DramRepository) -> Dram -> Void {
        return { repository.save($0) }
    }

    private static func transformItem() -> [String] -> Dram {
        return { components in
            let date = DramCSVDateFormatter.defaultInstance.dateFromString(components[0])

            let rating: Rating?
            if let rawValue = components[2].toInt() {
                rating = Rating(rawValue: rawValue)
            } else {
                rating = nil
            }

            return Dram(id: components[1], date: date, rating: rating)
        }
    }
}

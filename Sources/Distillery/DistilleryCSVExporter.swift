// Copyright 2014-2015 Ben Hale. All Rights Reserved


import ReactiveCocoa
import UIKit

final class DistilleryCSVExporter: NSObject {

    private let delegate: CSVExporter<Distillery>

    init(repository: DistilleryRepository, scheduler: SchedulerType, viewController: UIViewController) {
        self.delegate = CSVExporter(
            provideItems: DistilleryCSVExporter.provideItems(repository),
            scheduler: scheduler,
            transformItem: DistilleryCSVExporter.transformItem(),
            type: "Distilleries",
            viewController: viewController
        )
    }

    convenience init(viewController: UIViewController) {
        self.init(repository: DistilleryRepositoryManager.sharedInstance, scheduler: QueueScheduler(), viewController: viewController)
    }

    func exportDistilleries() {
        self.delegate.exportItems()
    }

    // MARK: -
    private static func provideItems(repository: DistilleryRepository) -> () -> [Distillery] {
        return { Array(repository.distilleries.value) }
    }

    private static func transformItem() -> Distillery -> [String] {
        return { distillery in [
            distillery.id ?? "",
            distillery.name ?? "",
            distillery.region?.rawValue ?? "",
            distillery.location?.coordinate.latitude.toString() ?? "",
            distillery.location?.coordinate.longitude.toString() ?? ""
            ] }
    }
}

extension Double {
    private func toString() -> String {
        return String(format: "%f", self)
    }
}
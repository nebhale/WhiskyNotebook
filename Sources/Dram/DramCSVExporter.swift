// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Foundation
import ReactiveCocoa
import UIKit

final class DramCSVExporter {

    private let delegate: CSVExporter<Dram>

    init(repository: DramRepository, scheduler: SchedulerType, viewController: UIViewController) {
        self.delegate = CSVExporter(
            provideItems: DramCSVExporter.provideItems(repository),
            scheduler: scheduler,
            transformItem: DramCSVExporter.transformItem(),
            type: "Drams",
            viewController: viewController
        )
    }

    convenience init(viewController: UIViewController) {
        self.init(repository: DramRepositoryManager.sharedInstance, scheduler: QueueScheduler(), viewController: viewController)
    }

    func exportDrams() {
        self.delegate.exportItems()
    }

    // MARK: -
    private static func provideItems(repository: DramRepository) -> () -> [Dram] {
        return { Array(repository.drams.value) }
    }

    private static func transformItem() -> Dram -> [String] {
        return { dram in [
            dram.date != nil ? DramCSVDateFormatter.defaultInstance.stringFromDate(dram.date!) : "",
            dram.id ?? "",
            dram.rating?.rawValue.toString() ?? ""
            ] }
    }
}

extension Int {
    private func toString() -> String {
        return String(format: "%d", self)
    }
}
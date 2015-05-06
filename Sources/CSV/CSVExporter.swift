// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Foundation
import LoggerLogger
import ReactiveCocoa
import UIKit

final class CSVExporter<T> {

    typealias ProvideItems = () -> [T]

    typealias TransformItem = T -> [String]

    private let documentMenuDelegate: UIDocumentMenuDelegate

    private let logger = Logger()

    private let provideItems: ProvideItems

    private let scheduler: SchedulerType

    private let transformItem: TransformItem

    private let type: String

    private let viewController: UIViewController

    init(provideItems: ProvideItems, scheduler: SchedulerType, transformItem: TransformItem, type: String, viewController: UIViewController) {
        let documentPickerDelegate = CSVExporterDocumentPickerDelegate(type: type)
        self.documentMenuDelegate = CSVDocumentMenuDelegate(documentPickerDelegate: documentPickerDelegate, viewController: viewController)

        self.provideItems = provideItems
        self.scheduler = scheduler
        self.transformItem = transformItem
        self.type = type
        self.viewController = viewController
    }

    func exportItems() {
        self.scheduler.schedule {
            self.logger.info("Exporting \(self.type) items")
            
            if let url = self.url(self.type) {
                let items = self.provideItems()
                let content = self.content(items)

                var error: NSError?
                content.writeToURL(url, atomically: true, encoding: NSUTF8StringEncoding, error: &error)

                if let error = error {
                    self.logger.error("Error exporting \(self.type) items: \(error)") // TODO: Handle errors better than this
                } else {
                    let documentMenuController = UIDocumentMenuViewController(URL: url, inMode: .ExportToService)
                    documentMenuController.delegate = self.documentMenuDelegate

                    self.viewController.presentViewController(documentMenuController, animated: true, completion: nil)
                }
            }
        }
    }

    private func content(items: [T]) -> String {
        return items.map(self.transformItem).map(lines) * "\n"
    }

    private func lines(components: [String]) -> String {
        return components * ","
    }

    private func url(type: String) -> NSURL? {
        return NSURL(fileURLWithPath: NSTemporaryDirectory().stringByAppendingPathComponent("\(type).csv"))
    }
}
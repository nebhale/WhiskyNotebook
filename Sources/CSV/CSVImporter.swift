// Copyright 2014-2015 Ben Hale. All Rights Reserved


import ReactiveCocoa
import UIKit

final class CSVImporter<T> {

    typealias SaveItem = T -> Void

    typealias TransformItem = [String] -> T

    private let documentMenuDelegate: UIDocumentMenuDelegate

    private let viewController: UIViewController

    init(saveItem: SaveItem, scheduler: SchedulerType, transformItem: TransformItem, type: String, viewController: UIViewController) {
        let documentPickerDelegate = CSVImporterDocumentPickerDelegate(saveItem: saveItem, scheduler: scheduler, type: type, transformItem: transformItem)
        self.documentMenuDelegate = CSVDocumentMenuDelegate(documentPickerDelegate: documentPickerDelegate, viewController: viewController)

        self.viewController = viewController
    }

    func importItems() {
        let documentMenuController = UIDocumentMenuViewController(documentTypes: ["public.comma-separated-values-text"], inMode: .Import)
        documentMenuController.delegate = self.documentMenuDelegate

        self.viewController.presentViewController(documentMenuController, animated: true, completion: nil)
    }
}
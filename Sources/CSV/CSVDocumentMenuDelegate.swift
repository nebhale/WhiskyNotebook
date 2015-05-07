// Copyright 2014-2015 Ben Hale. All Rights Reserved


import UIKit

final class CSVDocumentMenuDelegate: NSObject, UIDocumentMenuDelegate {

    private let documentPickerDelegate: UIDocumentPickerDelegate

    private let viewController: UIViewController

    init(documentPickerDelegate: UIDocumentPickerDelegate, viewController: UIViewController) {
        self.documentPickerDelegate = documentPickerDelegate
        self.viewController = viewController
    }

    func documentMenu(documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = documentPickerDelegate
        self.viewController.presentViewController(documentPicker, animated: true, completion: nil)
    }
}
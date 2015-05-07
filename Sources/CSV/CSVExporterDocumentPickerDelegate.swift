// Copyright 2014-2015 Ben Hale. All Rights Reserved


import LoggerLogger
import UIKit

final class CSVExporterDocumentPickerDelegate: NSObject, UIDocumentPickerDelegate {

    private let logger = Logger()

    private let type: String

    init(type: String) {
        self.type = type
    }

    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        self.logger.debug("Exported \(self.type) items to: \(url)")
    }
}
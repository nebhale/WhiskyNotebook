// Copyright 2014-2015 Ben Hale. All Rights Reserved


import LoggerLogger
import ReactiveCocoa
import UIKit

final class CSVImporterDocumentPickerDelegate: NSObject, UIDocumentPickerDelegate {

    private let logger = Logger()

    private let saveItem: Any -> Void

    private let scheduler: SchedulerType

    private let type: String

    private let transformItem: ([String]) -> Any

    init<T>(saveItem: T -> Void, scheduler: SchedulerType, type: String, transformItem: [String] -> T) {
        self.saveItem = { saveItem($0 as! T) }
        self.scheduler = scheduler
        self.type = type
        self.transformItem = { transformItem($0) }
    }

    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        Signal<String, NSError> { sink in
            return self.scheduler.schedule {
                self.logger.info("Importing \(self.type) items from: \(url)")

                var error: NSError?
                let contents = String(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: &error)

                if let error = error {
                    sendError(sink, error)
                } else if let contents = contents {
                    self.lines(contents).each { sendNext(sink, $0) }
                }

                sendCompleted(sink)
            }}
            |> map(components)
            |> map(transformItem)
            |> observe(
                completed: { self.logger.debug("Imported \(self.type) items") },
                error: { error in self.logger.error("Error importing \(self.type) items: \(error)") }, // TODO: Handle errors better than this
                next: self.saveItem
        )
    }

    private func components(line: String) -> [String] {
        return split(line) { $0 == "," }
    }

    private func lines(contents: String) -> [String] {
        return split(contents) { $0 == "\n" }
    }
}
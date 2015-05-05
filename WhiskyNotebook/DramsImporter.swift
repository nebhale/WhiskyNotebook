// Copyright 2014-2015 Ben Hale. All Rights Reserved


import LoggerLogger
import ReactiveCocoa
import UIKit

final class DramsImporter: NSObject, UIDocumentMenuDelegate, UIDocumentPickerDelegate {

    private let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return dateFormatter
        }()

    private let logger = Logger()

    var repository = DramRepositoryManager.sharedInstance

    var scheduler: SchedulerType = QueueScheduler()

    @IBOutlet
    var viewController: UIViewController!

    func documentMenu(documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.viewController.presentViewController(documentPicker, animated: true, completion: nil)
    }

    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        self.logger.info("Importing drams from: \(url)")

        Signal<String, NSError> { sink in
            return self.scheduler.schedule {
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
            |> map(dram)
            |> observe(
                error: { error in self.logger.error("Error importing drams: \(error)") }, // TODO: Handle errors better than this
                next: { self.repository.save($0) }
        )
    }

    @IBAction
    func importDrams() {
        self.logger.info("Import initiated")

        let documentMenuController = UIDocumentMenuViewController(documentTypes: ["public.comma-separated-values-text"], inMode: .Import)
        documentMenuController.delegate = self
        self.viewController.presentViewController(documentMenuController, animated: true, completion: nil)
    }

    private func components(line: String) -> [String] {
        return split(line, maxSplit: 3, allowEmptySlices: false) { $0 == "," }
    }

    private func dateFrom(rawValue: String) -> NSDate? {
        return self.dateFormatter.dateFromString(rawValue)
    }

    private func dram(components: [String]) -> Dram {
        let date = dateFrom(components[0])
        let rating = ratingFrom(components[2])
        return Dram(id: components[1], date: date, rating: rating)
    }

    private func lines(content: String) -> [String] {
        return split(content, maxSplit: Int.max, allowEmptySlices: false) { $0 == "\n" }
    }

    private func ratingFrom(rawValue: String) -> Rating? {
        if let rawValue = rawValue.toInt() {
            return Rating(rawValue: rawValue)
        } else {
            return nil
        }
    }
}
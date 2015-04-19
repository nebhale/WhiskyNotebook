// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa
import UIKit


public final class DramsExporter: NSObject, UIDocumentMenuDelegate, UIDocumentPickerDelegate {

    private let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return dateFormatter
        }()

    private let logger = Logger()

    public var repository = DramRepositoryManager.sharedInstance

    public var scheduler: SchedulerType = QueueScheduler()

    @IBOutlet
    public var viewController: UIViewController!

    public func documentMenu(documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.viewController.presentViewController(documentPicker, animated: true, completion: nil)
    }

    public func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        self.logger.info("Exported drams to: \(url)")
    }

    @IBAction
    public func exportDrams() {
        self.repository.drams
            |> observeOn(self.scheduler)
            |> start { drams in
                if let url = self.url() {
                    var error: NSError?
                    self.content(drams).writeToURL(url, atomically: true, encoding: NSUTF8StringEncoding, error: &error)

                    if let error = error {
                        self.logger.error("Error writing drams: \(error)") // TODO: Handle errors better
                    } else {
                        let documentMenuController = UIDocumentMenuViewController(URL: url, inMode: .ExportToService)
                        documentMenuController.delegate = self
                        self.viewController.presentViewController(documentMenuController, animated: true, completion: nil)
                    }
                }
        }
    }

    private func components(dram: Dram) -> [String] {
        return [
            dram.date != nil ? self.dateFormatter.stringFromDate(dram.date!) : "",
            dram.id ?? "",
            dram.rating?.rawValue.toString() ?? ""
        ]
    }

    private func content(drams: Set<Dram>) -> String {
        return "\n".join(Array(drams)
            .map(self.components)
            .map(self.lines))
    }

    private func lines(components: [String]) -> String {
        return ",".join(components)
    }

    private func url() -> NSURL? {
        return NSURL(fileURLWithPath: NSTemporaryDirectory().stringByAppendingPathComponent("drams.csv"))
    }
}

extension Int {
    func toString() -> String {
        return String(format: "%d", self)
    }
}
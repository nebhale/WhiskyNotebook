// Copyright 2014-2015 Ben Hale. All Rights Reserved

import ReactiveCocoa
import UIKit


public final class DistilleriesImporter: NSObject, UIDocumentMenuDelegate, UIDocumentPickerDelegate {

    private let logger = Logger()

    public var repository = DistilleryRepositoryManager.sharedInstance

    public var scheduler: SchedulerType = QueueScheduler()

    @IBOutlet
    public var viewController: UIViewController!

    public func documentMenu(documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.viewController.presentViewController(documentPicker, animated: true, completion: nil)
    }

    public func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        self.logger.info("Importing distilleries from: \(url)")

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
            |> map(distillery)
            |> observe(
                error: { error in self.logger.error("Error importing distilleries: \(error)") }, // TODO: Handle errors better than this
                next: { self.repository.save($0) }
        )
    }

    @IBAction
    public func importDistilleries() {
        self.logger.info("Import initiated")

        let documentMenuController = UIDocumentMenuViewController(documentTypes: ["public.comma-separated-values-text"], inMode: .Import)
        documentMenuController.delegate = self
        self.viewController.presentViewController(documentMenuController, animated: true, completion: nil)
    }

    private func components(line: String) -> [String] {
        return split(line, maxSplit: 5, allowEmptySlices: false) { $0 == "," }
    }

    private func distillery(components: [String]) -> Distillery {
        let location = locationFrom(components[3], components[4])
        return Distillery(id: components[0], location: location, name: components[1], region: Region(rawValue: components[2]))
    }

    private func lines(content: String) -> [String] {
        return split(content, maxSplit: Int.max, allowEmptySlices: false) { $0 == "\n" }
    }
    
}
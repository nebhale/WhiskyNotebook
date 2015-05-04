// Copyright 2014-2015 Ben Hale. All Rights Reserved


import LoggerLogger
import ReactiveCocoa
import UIKit

final class DistilleriesExporter: NSObject, UIDocumentMenuDelegate, UIDocumentPickerDelegate {

    private let logger = Logger()

    var repository = DistilleryRepositoryManager.sharedInstance

    var scheduler: SchedulerType = QueueScheduler()

    @IBOutlet
    var viewController: UIViewController!

    func documentMenu(documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.viewController.presentViewController(documentPicker, animated: true, completion: nil)
    }

    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        self.logger.info("Exported distilleries to: \(url)")
    }

    @IBAction
    func exportDistilleries() {
        self.repository.distilleries
            |> observeOn(self.scheduler)
            |> start { distilleries in
                if let url = self.url() {
                    var error: NSError?
                    self.content(distilleries).writeToURL(url, atomically: true, encoding: NSUTF8StringEncoding, error: &error)

                    if let error = error {
                        self.logger.error("Error writing distilleries: \(error)") // TODO: Handle errors better
                    } else {
                        let documentMenuController = UIDocumentMenuViewController(URL: url, inMode: .ExportToService)
                        documentMenuController.delegate = self
                        self.viewController.presentViewController(documentMenuController, animated: true, completion: nil)
                    }
                }
        }
    }

    private func components(distillery: Distillery) -> [String] {
        return [
            distillery.id ?? "",
            distillery.name ?? "",
            distillery.region?.rawValue ?? "",
            distillery.location?.coordinate.latitude.toString() ?? "",
            distillery.location?.coordinate.longitude.toString() ?? ""
        ]
    }

    private func content(distilleries: Set<Distillery>) -> String {
        return "\n".join(Array<Distillery>(distilleries)
            .map(self.components)
            .map(self.lines))
    }

    private func lines(components: [String]) -> String {
        return ",".join(components)
    }

    private func url() -> NSURL? {
        return NSURL(fileURLWithPath: NSTemporaryDirectory().stringByAppendingPathComponent("distilleries.csv"))
    }
}

extension Double {
    private func toString() -> String {
        return String(format: "%f", self)
    }
}
// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import ReactiveCocoa
import UIKit
import WhiskyNotebook


final class DramsExporterSpec: QuickSpec {
    override func spec() {
        var exporter: DramsExporter!
        var repository: DramRepository!
        var scheduler: TestScheduler!

        var presented = false

        beforeEach {
            repository = InMemoryDramRepository()
            scheduler = TestScheduler()

            let viewController = UIViewController()
            viewController.rac_signalForSelector(Selector("presentViewController:animated:completion:")).toSignalProducer()
                |> start{ _ in presented = true }

            exporter = DramsExporter()
            exporter.repository = repository
            exporter.scheduler = scheduler
            exporter.viewController = viewController
        }

        describe("Export Action") {
            it("presents menu") {
                exporter.exportDrams()
                scheduler.advance()
                expect(presented).to(beTruthy())
            }
        }

        describe("Document Menu") {
            var documentMenu: UIDocumentMenuViewController!
            var documentPicker: UIDocumentPickerViewController!

            beforeEach {
                documentMenu = UIDocumentMenuViewController()
                documentPicker = UIDocumentPickerViewController()
            }

            it("assigns itself as delegate") {
                exporter.documentMenu(documentMenu, didPickDocumentPicker: documentPicker)
                expect(documentPicker.delegate === exporter).to(beTruthy())
            }

            it("presents picker") {
                exporter.documentMenu(documentMenu, didPickDocumentPicker: documentPicker)
                expect(presented).to(beTruthy())
            }
        }

        describe("Document Picker") {
            pending("exports distilleries") {}
        }
    }
}
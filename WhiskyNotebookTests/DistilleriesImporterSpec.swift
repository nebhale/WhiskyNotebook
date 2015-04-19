// Copyright 2014-2015 Ben Hale. All Rights Reserved

import Nimble
import Quick
import ReactiveCocoa
import UIKit
import WhiskyNotebook


final class DistilleriesImporterSpec: QuickSpec {
    override func spec() {
        let bundle = NSBundle(forClass: self.dynamicType)

        describe("DistilleriesImporter") {
            var distilleries: Set<Distillery>!
            var importer: DistilleriesImporter!
            var repository: DistilleryRepository!
            var scheduler: TestScheduler!

            var presented = false

            beforeEach {
                repository = InMemoryDistilleryRepository()
                repository.distilleries
                    |> start { distilleries = $0 }

                scheduler = TestScheduler()

                let viewController = UIViewController()
                viewController.rac_signalForSelector(Selector("presentViewController:animated:completion:")).toSignalProducer()
                    |> start{ _ in presented = true }

                importer = DistilleriesImporter()
                importer.repository = repository
                importer.scheduler = scheduler
                importer.viewController = viewController
            }

            describe("Import Action") {
                it("presents menu") {
                    importer.importDistilleries()
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
                    importer.documentMenu(documentMenu, didPickDocumentPicker: documentPicker)
                    expect(documentPicker.delegate === importer).to(beTruthy())
                }

                it("presents picker") {
                    importer.documentMenu(documentMenu, didPickDocumentPicker: documentPicker)
                    expect(presented).to(beTruthy())
                }
            }

            describe("Document Picker") {
                it("imports distilleries") {
                    let url = bundle.URLForResource("Distilleries", withExtension: "csv")!

                    importer.documentPicker(UIDocumentPickerViewController(), didPickDocumentAtURL: url)
                    scheduler.advance()
                    
                    expect(distilleries.count).to(equal(3))
                }
            }
        }
    }
}
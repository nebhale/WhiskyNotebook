// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Foundation
import Nimble
import Quick
import ReactiveCocoa
import UIKit

final class DramCSVExporterSpec: QuickSpec {
    override func spec() {
        describe("DramCSVExporter") {
            var exporter: DramCSVExporter!
            var repository: DramRepository!
            var rootViewController: UIViewController!
            var scheduler: TestScheduler!

            beforeEach {
                repository = InMemoryDramRepository()
                rootViewController = UIViewController()
                scheduler = TestScheduler()

                exporter = DramCSVExporter(repository: repository, scheduler: scheduler, viewController: rootViewController)
            }

            context("action") {
                var presentedDocumentMenu: UIDocumentMenuViewController?

                beforeEach {
                    rootViewController.rac_signalForSelector(Selector("presentViewController:animated:completion:")).toSignalProducer()
                        |> map { $0 as? RACTuple }
                        |> map { $0?.first as? UIDocumentMenuViewController }
                        |> filter { $0 != nil }
                        |> start{ presentedDocumentMenu = $0 }

                    exporter.exportDrams()
                    scheduler.advance()
                }

                it("presents document menu") {
                    expect(presentedDocumentMenu).toNot(beNil())
                }

                context("document menu delegate") {
                    var documentMenu: UIDocumentMenuViewController!
                    var documentPicker: UIDocumentPickerViewController!
                    var presentedDocumentPicker: UIDocumentPickerViewController?

                    beforeEach {
                        documentMenu = UIDocumentMenuViewController()
                        documentPicker = UIDocumentPickerViewController()

                    rootViewController.rac_signalForSelector(Selector("presentViewController:animated:completion:")).toSignalProducer()
                            |> map { $0 as? RACTuple }
                            |> map { $0?.first as? UIDocumentPickerViewController }
                            |> filter { $0 != nil }
                            |> start{ presentedDocumentPicker = $0 }

                        presentedDocumentMenu?.delegate?.documentMenu(documentMenu, didPickDocumentPicker: documentPicker)
                    }

                    it("presents document picker") {
                        expect(presentedDocumentPicker).toNot(beNil())
                    }

                    context("document picker delegate") {
                        it("logs exported file") {
                            presentedDocumentPicker?.delegate?.documentPicker(documentPicker, didPickDocumentAtURL: NSURL(string: "http://localhost")!)
                        }
                    }
                }
            }
        }
    }
}

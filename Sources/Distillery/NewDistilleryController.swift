// Copyright 2014-2015 Ben Hale. All Rights Reserved


import CoreLocation
import ReactiveCocoa
import UIKit

final class NewDistilleryController: UITableViewController {

    @IBOutlet
    var id: UITextField!

    @IBOutlet
    var latitude: UITextField!

    @IBOutlet
    var longitude: UITextField!

    @IBOutlet
    var name: UITextField!

    @IBOutlet
    var region: UITextField!

    @IBOutlet
    var save: UIBarButtonItem!

    var repository = DistilleryRepositoryManager.sharedInstance

    var scheduler: SchedulerType = UIScheduler()

    override func viewDidLoad() {
        super.viewDidLoad()
        initSaveEnabled()
    }
}

// MARK: - Cancel
extension NewDistilleryController {

    @IBAction
    func cancelAndDismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - Save
extension NewDistilleryController {

    private func initSaveEnabled() {
        combineLatest(self.id.rac_textSignal().toSignalProducer(), self.latitude.rac_textSignal().toSignalProducer(), self.longitude.rac_textSignal().toSignalProducer(), self.name.rac_textSignal().toSignalProducer(), self.region.rac_textSignal().toSignalProducer())
            |> observeOn(self.scheduler)
            |> map { id, latitude, longitude, name, region in
                return (id as? String, latitude as? String, longitude as? String, name as? String, region as? String)
            }
            |> start { (id, latitude, longitude, name, region) in
                self.save.enabled = self.saveEnabled(id: id, latitude: latitude, longitude: longitude, name: name, region: region)
        }
    }

    @IBAction
    func saveAndDismiss() {
        let location = locationFrom(self.latitude.text, self.longitude.text)
        let distillery = Distillery(id: self.id.text, location: location, name: self.name.text, region: Region(rawValue: self.region.text))
        self.repository.save(distillery)

        self.dismissViewControllerAnimated(true, completion: nil)
    }

    private func saveEnabled(#id: String?, latitude: String?, longitude: String?, name: String?, region: String?) -> Bool {
        return (id?.validId() ?? false) && (latitude?.validLatitude() ?? false) && (longitude?.validLongitude() ?? false) && (name?.validName() ?? false) && (region?.validRegion() ?? false)
    }
}

extension Double {

    private func validLatitude() -> Bool {
        return self <= 90 && self >= -90
    }

    private func validLongitude() -> Bool {
        return self <= 180 && self >= -180
    }
}

extension String {

    private func validId() -> Bool {
        return self =~ "^[A-Z]?[\\d]{1,3}$"
    }

    private func validLatitude() -> Bool {
        return self.toDouble()?.validLatitude() ?? false
    }

    private func validLongitude() -> Bool {
        return self.toDouble()?.validLongitude() ?? false
    }

    private func validName() -> Bool {
        return self.length > 0
    }
    
    private func validRegion() -> Bool {
        return Region(rawValue: self) != nil
    }
}

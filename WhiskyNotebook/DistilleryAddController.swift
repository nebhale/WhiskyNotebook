// Copyright 2014-2015 Ben Hale. All Rights Reserved

import MapKit
import UIKit


final class DistilleryAddController: UIViewController, UIBarPositioningDelegate {

    private let logger = Logger(name: "DistilleryAddController")

    var importedDistillery: Distillery?

    @IBOutlet
    var mapView: MKMapView?

    @IBOutlet
    var saveButton: UIBarButtonItem?

    @IBAction
    func hideKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(false)
    }

    func pinLocation() {
        if validLatitude() && validLongitude() {
            if let latitude = dataController()?.latitude?.text.toDouble(), let longitude = dataController()?.longitude?.text.toDouble() {
                let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                DistilleryAnnotation(coordinate: coordinate).addToMapView(self.mapView)
            } else {
                self.logger.debug { "Unable to add annotation for \(self.dataController()?.latitude?.text), \(self.dataController()?.longitude?.text)" }
            }
        }
    }

    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }

    func toggleSaveButtonEnabled() {
        self.saveButton?.enabled = validId() && validName() && validRegion() && validLatitude() && validLongitude()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataController()?.id?.addTarget(self, action: "toggleSaveButtonEnabled", forControlEvents: UIControlEvents.EditingChanged)
        dataController()?.name?.addTarget(self, action: "toggleSaveButtonEnabled", forControlEvents: UIControlEvents.EditingChanged)
        dataController()?.region?.addTarget(self, action: "toggleSaveButtonEnabled", forControlEvents: UIControlEvents.EditingChanged)
        dataController()?.latitude?.addTarget(self, action: "toggleSaveButtonEnabled", forControlEvents: UIControlEvents.EditingChanged)
        dataController()?.longitude?.addTarget(self, action: "toggleSaveButtonEnabled", forControlEvents: UIControlEvents.EditingChanged)

        dataController()?.latitude?.addTarget(self, action: "pinLocation", forControlEvents: UIControlEvents.EditingChanged)
        dataController()?.longitude?.addTarget(self, action: "pinLocation", forControlEvents: UIControlEvents.EditingChanged)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        dataController()?.fromDistillery(self.importedDistillery)
        toggleSaveButtonEnabled()
        pinLocation()
    }

    private func dataController() -> DistilleryAddDataController? {
        return self.childViewControllers.first as? DistilleryAddDataController
    }

    private func validId() -> Bool {
        return dataController()?.id?.text.rangeOfString("[BGR\\d][\\d]*", options: .RegularExpressionSearch) != nil
    }

    private func validLatitude() -> Bool {
        return dataController()?.latitude?.text.toDouble() != nil
    }

    private func validLongitude() -> Bool {
        return dataController()?.longitude?.text.toDouble() != nil
    }

    private func validName() -> Bool {
        return dataController()?.region?.text.rangeOfString("[A-Za-z ]+", options: .RegularExpressionSearch) != nil
    }

    private func validRegion() -> Bool {
        return dataController()?.region?.text.rangeOfString("[A-Za-z ()]+", options: .RegularExpressionSearch) != nil
    }

}

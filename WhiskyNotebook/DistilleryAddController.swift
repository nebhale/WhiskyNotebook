// Copyright 2014-2015 Ben Hale. All Rights Reserved

import MapKit
import UIKit


final class DistilleryAddController: UIViewController, UIBarPositioningDelegate {
    
    private let logger = Logger(name: "DistilleryAddController")
    
    @IBOutlet
    var mapView: MKMapView?
    
    @IBOutlet
    var saveButton: UIBarButtonItem?
    
    func pinLocation() {
        if validLatitude() && validLongitude() {
            switch(self.mapView, dataController()?.latitude?.text.toDouble(), dataController()?.longitude?.text.toDouble()) {
            case(.Some(let mapView), .Some(let latitude), .Some(let longitude)):
                if let annotations = self.mapView?.annotations {
                    for annotation in annotations {
                        self.logger.debug { "Removing existing annotation \(annotation)" }
                        self.mapView?.removeAnnotation(annotation as MKAnnotation)
                    }
                }
                
                self.logger.debug { "Adding annotation for \(latitude), \(longitude)" }
                let location = CLLocationCoordinate2DMake(latitude, longitude)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                self.mapView?.addAnnotation(annotation)
                
                self.mapView?.setCenterCoordinate(location, animated: true)
                
                let region = MKCoordinateRegionMakeWithDistance(location, 250_000, 250_000)
                self.mapView?.setRegion(region, animated: true)
            default:
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
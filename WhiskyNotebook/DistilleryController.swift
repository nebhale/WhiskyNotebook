// Copyright 2014-2015 Ben Hale. All Rights Reserved

import MapKit
import UIKit


final class DistilleryController: UIViewController {

    private let locationManager = CLLocationManager()

    private let logger = Logger(name: "DistilleryController")
    
    @IBOutlet
    var mapView: MKMapView?
    
    var distillery: Distillery? {
        didSet {
            onMain {
                self.navigationItem.title = self.distillery?.name
                DistilleryAnnotation(distillery: self.distillery).addToMapView(self.mapView)
                (self.childViewControllers.first as? DistilleryDataController)?.region?.text = self.distillery?.region
            }
        }
    }
    
}
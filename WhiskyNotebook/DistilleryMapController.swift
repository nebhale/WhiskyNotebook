// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import CoreLocation
import LoggerLogger
import MapKit
import ReactiveCocoa
import UIKit


final class DistilleryMapController: UIViewController, MKMapViewDelegate {

    private var distillery: Distillery?

    private let logger = Logger()

    @IBOutlet
    var mapView: MKMapView! {
        willSet { newValue.delegate = self }
    }

    // MARK: -

    func configureWithDistillery(distillery: Distillery) {
        self.logger.debug("Configuring with \(distillery)")
        self.distillery = distillery
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let distillery = self.distillery else {
            return
        }

        self.navigationItem.title = distillery.name
        self.toolbarItems?.insert(MKUserTrackingBarButtonItem(mapView: self.mapView), atIndex: 0)
        self.toolbarItems?.append(UIBarButtonItem(customView: UIButton(type: .InfoLight)))
        DistilleryAnnotation(distillery: distillery).addToMapView(self.mapView)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: true)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }

    // MARK: Map View

    func mapViewWillStartLocatingUser(mapView: MKMapView) {
        self.logger.info("Requesting in use authorization")
        requestWhenInUseAuthorization()
            .filter { $0 == .AuthorizedWhenInUse }
            .observe(next: { authorizationStatus in
                self.logger.debug("Received in use authorization")
            })
    }

    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
}
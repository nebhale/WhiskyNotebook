// Copyright 2014-2015 Ben Hale. All Rights Reserved

import MapKit


final class DistilleryAnnotation: MKPointAnnotation {

    init(distillery: Distillery) {
        super.init()

        if let coordinate = distillery.location?.coordinate {
            self.coordinate = coordinate
        }
    }

    func addToMapView(mapView: MKMapView) {
        mapView.addAnnotation(self)
        mapView.setCenterCoordinate(self.coordinate, animated: true)
        mapView.setRegion(region(), animated: true)
    }

    private func region() -> MKCoordinateRegion {
        return MKCoordinateRegionMakeWithDistance(self.coordinate, 250_000, 250_000)
    }
}
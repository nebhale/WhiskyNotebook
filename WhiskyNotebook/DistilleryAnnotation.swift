// Copyright 2014-2015 Ben Hale. All Rights Reserved

import MapKit


final class DistilleryAnnotation: MKPointAnnotation {
    
    init(coordinate: CLLocationCoordinate2D?) {
        super.init()
        
        if let coordinate = coordinate {
            self.coordinate = coordinate
        }
    }
    
    convenience init(distillery: Distillery?) {
        self.init(coordinate: distillery?.location?.coordinate)
    }
    
    func addToMapView(mapView: MKMapView?) {
        removeExistingAnnotations(mapView)
        
        mapView?.addAnnotation(self)
        mapView?.setCenterCoordinate(self.coordinate, animated: true)
        mapView?.setRegion(region(), animated: true)
    }
    
    private func region() -> MKCoordinateRegion {
        return MKCoordinateRegionMakeWithDistance(coordinate, 250_000, 250_000)
    }
    
    private func removeExistingAnnotations(mapView: MKMapView?) {
        if let annotations = mapView?.annotations {
            for annotation in annotations {
                mapView?.removeAnnotation(annotation as MKAnnotation)
            }
        }
    }
    
}
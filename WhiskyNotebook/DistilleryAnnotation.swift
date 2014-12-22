// Copyright 2014 Ben Hale. All Rights Reserved

import MapKit

final class DistilleryAnnotation: MKPointAnnotation {
    
    init(_ distillery: Distillery) {
        super.init()
        
        self.coordinate = CLLocationCoordinate2DMake(distillery.latitude, distillery.longitude)
        self.title = distillery.name
    }
}
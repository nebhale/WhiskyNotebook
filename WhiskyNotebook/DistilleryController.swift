// Copyright 2014 Ben Hale. All Rights Reserved

import UIKit
import MapKit

final class DistilleryController: UIViewController {
    
    // MARK: Properties
    
    var distillery: Distillery?
    
    private let edgeInsets = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone ? UIEdgeInsetsMake(75, 0, 75, 0) : UIEdgeInsetsZero
    
    private let ireland = DistilleryController.bounds([(55.430019, -7.23381), (51.384167, -9.600278), (52.075683, -10.661283), (54.407972, -5.366556)])
    
    private let japan = DistilleryController.bounds([(45.522778, 141.936389), (30.994167, 130.660639), (43.385, 145.8175), (33.217778, 129.5525)])
    
    private let logger = Logger("DistilleryController")
    
    private let scotland = DistilleryController.bounds([(59, -3), (58.65, -3.25), (54.633333, -4.866667), (56.7, -6.216667)])
    
    private let wales = DistilleryController.bounds([(53.433333, -4.433333), (51.366667, -3.116667), (51.816667, -2.65), (51.72125, -5.66981)])
    
    @IBOutlet
    var mapView: MKMapView?
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.distillery?.name
        
        if let mapView = self.mapView {
            if let distillery = self.distillery {
                
                var mapRect: MKMapRect
                switch distillery.region {
                case .Ireland:
                    mapRect = self.ireland
                case .Japan:
                    mapRect = self.japan
                case .Wales:
                    mapRect = self.wales
                default:
                    mapRect = self.scotland
                }
                
                mapView.visibleMapRect = mapView.mapRectThatFits(mapRect, edgePadding: self.edgeInsets)
                mapView.addAnnotation(DistilleryAnnotation(distillery))
            }
        }
    }
    
    // MARK:
    
    private class func bounds(points: [(latitude: Double, longitude: Double)]) -> MKMapRect {
        var coordinates: [CLLocationCoordinate2D] = []
        
        for (latitude, longitude) in points {
            coordinates.append(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        }
        
        return MKPolygon(coordinates: &coordinates, count: coordinates.count).boundingMapRect
    }
    
    
    
    
    private class func foo() -> String? {
        return nil
    }
    
    private let bar: String? = {
        return DistilleryController.foo()
        }()
    
}

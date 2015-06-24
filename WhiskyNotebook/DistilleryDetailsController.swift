// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import LoggerLogger
import MapKit
import UIKit


final class DistilleryDetailsController: UIViewController {

    private var distillery: Distillery?

    @IBOutlet
    var id: UILabel!

    private let logger = Logger()

    @IBOutlet
    var mapView: MKMapView!

    @IBOutlet
    var name: UILabel!

    @IBOutlet
    var region: UILabel!

    // MARK: -

    func configureWithDistillery(distillery: Distillery) {
        self.logger.debug("Configuring with \(distillery)")
        self.distillery = distillery
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier {
        case .Some("DistilleryMap"):
            if let viewController = segue.destinationViewController as? DistilleryMapController, let distillery = distillery {
                viewController.configureWithDistillery(distillery)
            }
        default:
            self.logger.warn("Unknown segue \(segue.identifier)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let distillery = self.distillery else {
            return
        }

        self.id.text = distillery.id
        self.name.text = distillery.name
        self.region.text = distillery.region?.rawValue
        DistilleryAnnotation(distillery: distillery).addToMapView(self.mapView)
    }
}
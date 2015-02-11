// Copyright 2014-2015 Ben Hale. All Rights Reserved

import CoreLocation
import UIKit


final class DistilleryAddDataController: UITableViewController, UITextFieldDelegate {

    private let logger = Logger(name: "DistilleryAddDataController")

    @IBOutlet
    var id: UITextField?

    @IBOutlet
    var name: UITextField?

    @IBOutlet
    var region: UITextField?

    @IBOutlet
    var latitude: UITextField?

    @IBOutlet
    var longitude: UITextField?

    func fromDistillery(distillery: Distillery?) {
        self.id?.text = distillery?.id
        self.name?.text = distillery?.name
        self.region?.text = distillery?.region

        if let location = distillery?.location {
            self.latitude?.text = location.coordinate.latitude.description
            self.longitude?.text = location.coordinate.longitude.description
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return ChainedTextField.textFieldShouldReturn(textField)
    }

    func toDistillery() -> Distillery? {
        if let id = self.id?.text, let name = self.name?.text, let region = self.region?.text, let latitude = self.latitude?.text.toDouble(), let longitude = self.longitude?.text.toDouble() {
            let distillery = Distillery()

            distillery.id = id
            distillery.name = name
            distillery.region = region
            distillery.location = CLLocation(latitude: latitude, longitude: longitude)

            return distillery
        } else {
            return nil
        }
    }
}

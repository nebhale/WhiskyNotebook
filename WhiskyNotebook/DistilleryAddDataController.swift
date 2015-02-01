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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return ChainedTextField.textFieldShouldReturn(textField)
    }
    
    func fromDistillery(distillery: Distillery?) {
        self.id?.text = distillery?.id
        self.name?.text = distillery?.name
        self.region?.text = distillery?.region
        
        if let location = distillery?.location? {
            self.latitude?.text = location.coordinate.latitude.description
            self.longitude?.text = location.coordinate.longitude.description
        }
    }
    
    func toDistillery() -> Distillery? {
        switch(self.id?.text, self.name?.text, self.region?.text, self.latitude?.text.toDouble(), self.longitude?.text.toDouble()) {
        case(.Some(let id), .Some(let name), .Some(let region), .Some(let latitude), .Some(let longitude)):
            let distillery = Distillery()
            
            distillery.id = id
            distillery.name = name
            distillery.region = region
            distillery.location = CLLocation(latitude: latitude, longitude: longitude)
            
            return distillery
        default:
            return nil
        }
    }
}
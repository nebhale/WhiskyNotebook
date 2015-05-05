// Copyright 2014-2015 Ben Hale. All Rights Reserved


import CoreLocation

func locationFrom(latitude: String, longitude: String) -> CLLocation? {
    if let latitude = latitude.toDouble(), let longitude = longitude.toDouble() {
        return CLLocation(latitude: latitude, longitude: longitude)
    } else {
        return nil
    }
}
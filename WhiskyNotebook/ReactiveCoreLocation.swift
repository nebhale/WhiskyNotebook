// Copyright 2014-2015 Ben Hale.  All Rights Reserved.

import CloudKit
import ReactiveCocoa


func requestWhenInUseAuthorization() -> Signal<CLAuthorizationStatus, NoError> {
    return Signal { observer in
        let locationManager = CLLocationManager()
        let locationManagerDelegate = LocationManagerDelegate(observer: observer)
        locationManager.delegate = locationManagerDelegate

        locationManager.requestWhenInUseAuthorization()

        return LocationManagerDisposable(locationManager: locationManager, locationManagerDelegate: locationManagerDelegate)
    }
}

private final class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {

    private let observer: Event<CLAuthorizationStatus, NoError> -> ()

    init(observer: Event<CLAuthorizationStatus, NoError> -> ()) {
        self.observer = observer
    }

    @objc
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        sendNext(self.observer, status)

        if status != .NotDetermined {
            sendCompleted(self.observer)
        }
    }
}

private final class LocationManagerDisposable: Disposable {

    var disposed = false

    private var locationManager: CLLocationManager

    private var locationManagerDelegate: CLLocationManagerDelegate

    init(locationManager: CLLocationManager, locationManagerDelegate: LocationManagerDelegate) {
        self.locationManager = locationManager
        self.locationManagerDelegate = locationManagerDelegate
    }

    func dispose() {
        self.disposed = true
    }
}
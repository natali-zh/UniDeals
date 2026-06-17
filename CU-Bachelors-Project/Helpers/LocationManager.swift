//
//  LocationManager.swift
//  CU-Bachelors-Project
//

import CoreLocation
import Observation

@MainActor
@Observable
final class LocationManager: NSObject {

    static let shared = LocationManager()

    var userLocation: CLLocationCoordinate2D?
    var locationUpdateCount: Int = 0
    var authorizationStatus: CLAuthorizationStatus = .notDetermined

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        authorizationStatus = manager.authorizationStatus
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            authorizationStatus = manager.authorizationStatus
            if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
                manager.startUpdatingLocation()
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            userLocation = locations.last?.coordinate
            locationUpdateCount += 1
            manager.stopUpdatingLocation()
        }
    }
}

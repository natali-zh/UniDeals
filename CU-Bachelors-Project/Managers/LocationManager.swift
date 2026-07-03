import CoreLocation
import Observation

@MainActor
@Observable
final class LocationManager: NSObject {
    
    //MARK: - Properties
    
    static let shared = LocationManager()
    
    var userLocation: CLLocationCoordinate2D?
    var locationUpdateCount: Int = 0
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private let manager = CLLocationManager()
    
    //MARK: - Init
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        authorizationStatus = manager.authorizationStatus
    }
    
    //MARK: - Methods
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
}

//MARK: - Extensions

extension LocationManager: CLLocationManagerDelegate {
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            authorizationStatus = status
            if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
                self.manager.startUpdatingLocation()
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coordinate = locations.last?.coordinate
        Task { @MainActor in
            userLocation = coordinate
            locationUpdateCount += 1
            self.manager.stopUpdatingLocation()
        }
    }
}

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

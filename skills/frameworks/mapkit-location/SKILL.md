---
name: mapkit-location
description: Implement maps and location services using MapKit and CoreLocation for displaying maps, annotations, routes, geofencing, user location tracking, geocoding, and navigation. Use when adding maps to your app, tracking user location, showing points of interest, or implementing location-based features.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# MapKit and Location Services

## What This Skill Does

Provides comprehensive guidance on implementing maps and location features using MapKit and CoreLocation frameworks. Covers map display, annotations, user location, geocoding, routing, geofencing, and location permissions.

## When to Activate

- Displaying maps in your application
- Tracking user location
- Adding annotations and overlays to maps
- Implementing geofencing and region monitoring
- Geocoding addresses or reverse geocoding coordinates
- Showing directions and routes
- Requesting location permissions

## Core Concepts

### MapKit Framework

**MKMapView**: Display maps with annotations, overlays, and user tracking
**MKAnnotation**: Mark points of interest on map
**MKOverlay**: Draw shapes (circles, polygons, polylines) on map
**MKRoute**: Display directions between locations

### CoreLocation Framework

**CLLocationManager**: Request permissions and receive location updates
**CLLocation**: Represents a geographic coordinate
**CLGeocoder**: Convert addresses to coordinates and vice versa
**CLRegion**: Define geographic regions for monitoring

## Implementation Patterns

### Displaying a Map (SwiftUI)

```swift
import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        Map(coordinateRegion: $region)
            .edgesIgnoringSafeArea(.all)
    }
}

// With annotations
struct Place: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct AnnotatedMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    let places = [
        Place(name: "Golden Gate Bridge", coordinate: CLLocationCoordinate2D(latitude: 37.8199, longitude: -122.4783)),
        Place(name: "Alcatraz", coordinate: CLLocationCoordinate2D(latitude: 37.8267, longitude: -122.4233))
    ]

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: places) { place in
            MapMarker(coordinate: place.coordinate, tint: .red)
            // Or custom annotation
            MapAnnotation(coordinate: place.coordinate) {
                VStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                    Text(place.name)
                        .font(.caption)
                }
            }
        }
    }
}
```

### Requesting Location Permissions

```swift
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
        // Or for background: manager.requestAlwaysAuthorization()
    }

    func startUpdating() {
        manager.startUpdatingLocation()
    }

    func stopUpdating() {
        manager.stopUpdatingLocation()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdating()
        case .denied, .restricted:
            print("Location access denied")
        case .notDetermined:
            requestPermission()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }
        location = latest
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}

// Info.plist keys required:
// NSLocationWhenInUseUsageDescription: "We need your location to show nearby places"
// NSLocationAlwaysAndWhenInUseUsageDescription: "We need your location for geofencing"
```

### User Location on Map

```swift
struct UserLocationMapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow))
            .onAppear {
                locationManager.requestPermission()
            }
            .onChange(of: locationManager.location) { _, newLocation in
                if let coordinate = newLocation?.coordinate {
                    region.center = coordinate
                }
            }
    }
}
```

### Geocoding and Reverse Geocoding

```swift
class GeocodingService {
    private let geocoder = CLGeocoder()

    // Address to coordinates
    func geocode(address: String) async throws -> CLLocationCoordinate2D {
        let placemarks = try await geocoder.geocodeAddressString(address)

        guard let location = placemarks.first?.location else {
            throw GeocodingError.noResults
        }

        return location.coordinate
    }

    // Coordinates to address
    func reverseGeocode(coordinate: CLLocationCoordinate2D) async throws -> String {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let placemarks = try await geocoder.reverseGeocodeLocation(location)

        guard let placemark = placemarks.first else {
            throw GeocodingError.noResults
        }

        var addressComponents: [String] = []

        if let name = placemark.name {
            addressComponents.append(name)
        }
        if let city = placemark.locality {
            addressComponents.append(city)
        }
        if let state = placemark.administrativeArea {
            addressComponents.append(state)
        }
        if let zip = placemark.postalCode {
            addressComponents.append(zip)
        }

        return addressComponents.joined(separator: ", ")
    }
}

enum GeocodingError: Error {
    case noResults
}

// Usage
Task {
    let service = GeocodingService()

    // Forward geocoding
    let coordinate = try await service.geocode(address: "1 Apple Park Way, Cupertino, CA")
    print("Coordinates: \(coordinate.latitude), \(coordinate.longitude)")

    // Reverse geocoding
    let address = try await service.reverseGeocode(coordinate: coordinate)
    print("Address: \(address)")
}
```

### Directions and Routes

```swift
func getDirections(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) async throws -> MKRoute {
    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
    request.transportType = .automobile

    let directions = MKDirections(request: request)
    let response = try await directions.calculate()

    guard let route = response.routes.first else {
        throw MapError.noRoute
    }

    return route
}

// Display route on map
struct DirectionsMapView: View {
    @State private var route: MKRoute?
    @State private var region = MKCoordinateRegion()

    let source = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    let destination = CLLocationCoordinate2D(latitude: 37.8199, longitude: -122.4783)

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: annotations) { annotation in
            MapMarker(coordinate: annotation.coordinate)
        }
        .overlay(
            RouteOverlay(route: route)
        )
        .task {
            do {
                route = try await getDirections(from: source, to: destination)
                if let route = route {
                    region = MKCoordinateRegion(route.polyline.boundingMapRect)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
```

### Geofencing and Region Monitoring

```swift
class GeofenceManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
    }

    func startMonitoring(center: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String) {
        let region = CLCircularRegion(
            center: center,
            radius: radius,
            identifier: identifier
        )
        region.notifyOnEntry = true
        region.notifyOnExit = true

        manager.startMonitoring(for: region)
    }

    func stopMonitoring(identifier: String) {
        for region in manager.monitoredRegions {
            if region.identifier == identifier {
                manager.stopMonitoring(for: region)
            }
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered region: \(region.identifier)")
        // Send notification, update UI, etc.
        sendLocalNotification(title: "Welcome!", body: "You entered \(region.identifier)")
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited region: \(region.identifier)")
        sendLocalNotification(title: "Goodbye!", body: "You left \(region.identifier)")
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed: \(error.localizedDescription)")
    }

    private func sendLocalNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request)
    }
}
```

### Custom Annotations (UIKit)

```swift
import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D

    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}

class CustomAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let custom = newValue as? CustomAnnotation else { return }

            canShowCallout = true
            markerTintColor = .systemBlue
            glyphImage = UIImage(systemName: "star.fill")

            // Add detail button
            let button = UIButton(type: .detailDisclosure)
            rightCalloutAccessoryView = button
        }
    }
}

// In UIViewController
class MapViewController: UIViewController, MKMapViewDelegate {
    let mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

        let annotation = CustomAnnotation(
            title: "Important Place",
            subtitle: "This is a landmark",
            coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        )

        mapView.addAnnotation(annotation)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Selected annotation: \(view.annotation?.title ?? "")")
    }
}
```

## Best Practices

1. **Request appropriate permission level** - WhenInUse vs Always based on actual need

2. **Explain permission purpose** - Clear NSLocationUsageDescription in Info.plist

3. **Stop location updates when not needed** - Conserve battery

4. **Use appropriate accuracy** - Balance between accuracy and battery life

5. **Handle permission denial gracefully** - Provide fallback or guide to Settings

6. **Cache geocoding results** - Avoid repeated API calls

7. **Limit geofence regions** - iOS limits to 20 monitored regions per app

8. **Test on device** - Location services don't work well in Simulator

9. **Handle background location carefully** - Requires Always authorization

10. **Respect user privacy** - Don't track more than necessary

## Common Pitfalls

1. **Missing Info.plist keys**
   - ❌ No usage description
   - ✅ Add NSLocationWhenInUseUsageDescription

2. **Not stopping location updates**
   - ❌ Continuous updates drain battery
   - ✅ Call stopUpdatingLocation() when done

3. **Wrong accuracy for use case**
   - ❌ kCLLocationAccuracyBest for coarse needs
   - ✅ kCLLocationAccuracyHundredMeters for city-level

4. **Not handling permission denial**
   - ❌ Assuming permission granted
   - ✅ Check authorizationStatus

5. **Geocoding in loop**
   - ❌ Geocode every coordinate individually
   - ✅ Batch or cache results

6. **Too many geofence regions**
   - ❌ Monitor 50 regions
   - ✅ Limit to 20 most relevant

7. **Testing only in Simulator**
   - ❌ Simulator location inaccurate
   - ✅ Test on real device

8. **Blocking main thread**
   - ❌ Synchronous geocoding
   - ✅ Use async await

## Related Skills

- `swiftui-essentials` - Map in SwiftUI
- `app-lifecycle` - Location in background
- `privacy-compliance` - Location permissions
- `debugging-basics` - Debug location issues

## Example Scenarios

### Scenario 1: Nearby Places Finder

```swift
@MainActor
class NearbyPlacesViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocation?
    @Published var places: [Place] = []

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }

    func findNearbyPlaces() async {
        guard let location = userLocation else { return }

        // Search for nearby places
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "restaurants"
        request.region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )

        let search = MKLocalSearch(request: request)

        do {
            let response = try await search.start()
            places = response.mapItems.map { item in
                Place(
                    name: item.name ?? "Unknown",
                    coordinate: item.placemark.coordinate
                )
            }
        } catch {
            print("Search error: \(error)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
    }
}
```

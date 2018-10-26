//: A MapKit based Playground

import MapKit
import PlaygroundSupport

class TestMapView: NSObject {
    
}

extension TestMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isEqual(mapView.userLocation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation")
        
        if annotationView == nil {
            annotationView = PubAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named:"icons8-map-pin-filled-50")
        
        return annotationView
    }
}

let appleParkWayCoordinates = CLLocationCoordinate2DMake(37.334922, -122.009033)

// Now let's create a MKMapView
let mapView = MKMapView(frame: CGRect(x:0, y:0, width:800, height:800))

// Define a region for our map view
var mapRegion = MKCoordinateRegion()

let mapRegionSpan = 0.02
mapRegion.center = appleParkWayCoordinates
mapRegion.span.latitudeDelta = mapRegionSpan
mapRegion.span.longitudeDelta = mapRegionSpan

mapView.setRegion(mapRegion, animated: true)

// Create a map annotation
let annotation = MKPointAnnotation()
annotation.coordinate = appleParkWayCoordinates
annotation.title = "Apple Inc."
annotation.subtitle = "One Apple Park Way, Cupertino, California."

//mapView.addAnnotation(annotation)

let dictionary1 = ["name": "EXPEDITO BAR E ESPETO",
                   "address": "Rua Ibituruna 1540 Campo Belo SÃo Paulo SP 04302-050",
                   "phone": "11-5044-4887",
                   "desc": "Bar famoso pela variedade de espetinhos, cervejas e caipirinhas.",
                   "lat": -23.6256824,
                   "lng": -46.6692779] as [String : Any]

let jsonData = try! JSONSerialization.data(withJSONObject: dictionary1, options: .prettyPrinted)

let pub = try! JSONDecoder().decode(Pub.self, from: jsonData)
let pubAnnotation = PubAnnotation(pub: pub)
pubAnnotation.coordinate = appleParkWayCoordinates
mapView.addAnnotation(pubAnnotation)

let testMapView = TestMapView()
mapView.delegate = testMapView

// Add the created mapView to our Playground Live View
PlaygroundPage.current.liveView = mapView

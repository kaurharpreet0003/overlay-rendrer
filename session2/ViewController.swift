//
//  ViewController.swift
//  session2
//
//  Created by MacStudent on 2020-01-10.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    let places = Place.getPlaces()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        addAnnotation()
        addPolyLine()
    }
    
    
    func addAnnotation() {
        mapView.delegate = self
        mapView.addAnnotations(places)
        
        let overLays = places.map{ (MKCircle(center: $0.coordinate, radius: 100))}
        mapView.addOverlays(overLays)
    }
    
    
    func addPolyLine() {
        let locations = places.map{$0.coordinate}
        let polyLine = MKPolyline(coordinates: locations, count: locations.count)
        mapView.addOverlay(polyLine)
        
    }

}


extension ViewController:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }else{
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "ic_place")
            return annotationView
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
        let rendrer = MKCircleRenderer(overlay: overlay)
        rendrer.fillColor = UIColor.black.withAlphaComponent(0.5)
        rendrer.strokeColor = UIColor.green
        rendrer.lineWidth = 2
        return rendrer
        }else if overlay is MKPolyline {
            let rendrer = MKPolylineRenderer(overlay: overlay)
            rendrer.strokeColor = UIColor.blue
            return rendrer
        }else if overlay is MKPolygon{
            let rendrer = MKPolygonRenderer(overlay: overlay)
            rendrer.fillColor = UIColor.black.withAlphaComponent(0.0)
            rendrer.strokeColor = UIColor.orange
            rendrer.lineWidth = 2
            return rendrer
        }
        return MKOverlayRenderer()
    }
}

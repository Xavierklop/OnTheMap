//
//  FirstViewController.swift
//  OnTheMap
//
//  Created by Hao Wu on 02.06.19.
//  Copyright © 2019 Hao Wu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadMapView()
    }
    
    @IBAction func refresh(_ sender: Any) {
        loadMapView()
    }
    
    func setupMapView() {
        var annotations = [MKPointAnnotation]()
        
        for dictionary in OnTheMapModel.studentsLocation {
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL

            annotations.append(annotation)
            
        }
        if OnTheMapModel.didPostUserLocation {
            let latitude:CLLocationDegrees = CLLocationDegrees(OnTheMapModel.studentsLocation[0].latitude)
            let longitude:CLLocationDegrees = CLLocationDegrees(OnTheMapModel.studentsLocation[0].longitude)
            let latDelta:CLLocationDegrees = 0.05
            let lonDelta:CLLocationDegrees = 0.05
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let location = CLLocationCoordinate2DMake(latitude, longitude)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: false)
        }
        
        mapView.addAnnotations(annotations)
    }
    
    func showFailure(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func loadMapView() {
        activityIndicator.startAnimating()
        OnTheMapClient.getStudentsLocation { (studentsResponse, error) in
            if let studentsResponse = studentsResponse {
                OnTheMapModel.studentsLocation = studentsResponse.results
                self.setupMapView()
                self.activityIndicator.stopAnimating()
            } else {
                self.showFailure(title: "Download Fails", message: "Please try again.")
            }
        }
    }

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                let url = URL(string: toOpen)
                guard let openURL = url else {
                    print("no url")
                    return
                }
                let app = UIApplication.shared
                let URLCanOpen = app.canOpenURL(openURL)
                if URLCanOpen {
                    app.open(openURL)
                } else {
                    showFailure(title: "URL is invaild", message: "The URL of student is invaild, can not open this URL.")
                }
            }
        }
    }
    
    
}


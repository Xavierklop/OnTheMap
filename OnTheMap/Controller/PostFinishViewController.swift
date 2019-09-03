//
//  PostFinishViewController.swift
//  OnTheMap
//
//  Created by Hao Wu on 10.06.19.
//  Copyright © 2019 Hao Wu. All rights reserved.
//

import UIKit
import MapKit

class PostFinishViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMapView()
        
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finish(_ sender: Any) {
        handlePostOrPutLocation()
    }
    
    private func handlePostOrPutLocation() {
        if OnTheMapModel.onlyStudentLocationExist {
            OnTheMapClient.putStudentLocation { (success, error) in
                if success {
                    OnTheMapModel.didPostUserLocation = true
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                } else {
                    self.showFailure(title: "Post Location Fails", message: "Please try again.")
                }
            }
        } else {
            OnTheMapClient.postStudentLocation { (success, error) in
                if success {
                    OnTheMapModel.didPostUserLocation = true
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                } else {
                    self.showFailure(title: "Post Location Fails", message: "Please try again.")
                }
            }
            
        }
    }
    
    func presentMapVC() {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "MapViewController") as UIViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    func loadMapView() {
        activityIndicator.startAnimating()
        setupMapView()
        activityIndicator.stopAnimating()
    }
    
    func setupMapView() {
        
        let lat = CLLocationDegrees(OnTheMapClient.StudentLocation.latitude)
        let long = CLLocationDegrees(OnTheMapClient.StudentLocation.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
        let first = OnTheMapClient.StudentLocation.firstName
        let last = OnTheMapClient.StudentLocation.lastName
        let mediaURL = OnTheMapClient.StudentLocation.mediaURL
            
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        
        let latitude:CLLocationDegrees = lat
        let longitude:CLLocationDegrees = long
        let latDelta:CLLocationDegrees = 0.05
        let lonDelta:CLLocationDegrees = 0.05
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: false)
        
        mapView.addAnnotation(annotation)
        
    }
    
    func showFailure(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}

extension PostFinishViewController: MKMapViewDelegate {
    
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
    
    
}

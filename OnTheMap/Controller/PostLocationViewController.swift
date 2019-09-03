//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Hao Wu on 08.06.19.
//  Copyright © 2019 Hao Wu. All rights reserved.
//

import UIKit
import CoreLocation

class PostLocationViewController: UIViewController {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UdacityClient.getPublicUserData(uniqueKey: OnTheMapClient.StudentLocation.uniqueKey) { (success, error) in }
    }
    
    @IBAction func cancelPostingLocation(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        if locationTextField.text!.isEmpty || linkTextField.text!.isEmpty {
            showAlert(title: "No Location or Link", message: "Location and Link are required!")
        } else {
            guard let link = linkTextField.text else { return }
            let app = UIApplication.shared
            let url = URL(string: link)
            guard let openURL = url else {
                print("no url")
                return
            }
            let URLCanOpen = app.canOpenURL(openURL)
            if URLCanOpen {
                OnTheMapClient.StudentLocation.mediaURL = link
                geocode()
            } else {
                showFailure(message: "This URL invaild, try anther URL.")
            }
            
        }
    }
    
    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "URL is invaild", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func presentPostFinishVC() {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "PostFinishViewController") as UIViewController
        self.present(controller, animated: true, completion: nil)
    }
    
}

extension PostLocationViewController {
    func geocode() {
        activityIndicator.startAnimating()
        guard let adress = locationTextField.text else { return }
        geocoder.geocodeAddressString(adress) { (placemarks, error) in
            self.processGeocodeResponse(withPlacemarks: placemarks, error: error)
            self.presentPostFinishVC()
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func processGeocodeResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        if let error = error {
            print("Unable to Forward Geocode Address with error: (\(error))")
            showAlert(title: "Oops!", message: "Unable to Find Location for Address.")
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                OnTheMapClient.StudentLocation.latitude = coordinate.latitude
                OnTheMapClient.StudentLocation.longitude = coordinate.longitude
               
            } else {
                showAlert(title: "No Matching Location", message: "No Matching Location Found, please add more detail adress.")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}

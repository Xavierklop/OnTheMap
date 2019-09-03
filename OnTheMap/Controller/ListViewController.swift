//
//  SecondViewController.swift
//  OnTheMap
//
//  Created by Hao Wu on 02.06.19.
//  Copyright © 2019 Hao Wu. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    @IBAction func refresh(_ sender: Any) {
        activityIndicator.startAnimating()
        OnTheMapClient.getStudentsLocation { (studentsResponse, error) in
            if let studentsResponse = studentsResponse {
                OnTheMapModel.studentsLocation = studentsResponse.results
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            } else {
                self.showFailure(title: "Download Fails", message: "Please try again.")
            }
        }
    }
    
    func showFailure(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OnTheMapModel.studentsLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailViewCell")!
        
        let student = OnTheMapModel.studentsLocation[indexPath.row]
        cell.textLabel?.text = student.firstName + " " + student.lastName
        cell.detailTextLabel?.text = student.mediaURL
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = OnTheMapModel.studentsLocation[indexPath.row]
        let url = URL(string: student.mediaURL)
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


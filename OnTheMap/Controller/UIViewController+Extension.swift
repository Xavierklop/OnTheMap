//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Hao Wu on 04.06.19.
//  Copyright © 2019 Hao Wu. All rights reserved.
//

import UIKit

extension UIViewController {

    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addLocation(_ sender: UIBarButtonItem) {
        
        OnTheMapClient.getOnlyStudentLocation { (onlyStudentResponse, error) in
            guard let onlyStudentResponse = onlyStudentResponse  else {
                print("no only student response")
                return
            }
            OnTheMapModel.onlyStudentLocationExist = onlyStudentResponse.results != nil
            if OnTheMapModel.onlyStudentLocationExist {
                let alert = UIAlertController(title: nil, message: "You have already posted a Student Location. Would you like to overwrite your current location?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { action in
                    self.presentPostVC()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else {
                self.presentPostVC()
            }
        }
        
    }
    
    func presentPostVC() {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "PostLocationViewController") as UIViewController
        self.present(controller, animated: true, completion: nil)
    }
}

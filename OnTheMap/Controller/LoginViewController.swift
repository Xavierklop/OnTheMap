//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Hao Wu on 02.06.19.
//  Copyright © 2019 Hao Wu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        setLogin(true)
        UdacityClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
       
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let url = UdacityClient.Endpoints.signUp.url
        UIApplication.shared.open(url)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        setLogin(false)
        if success {
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func setLogin(_ tap: Bool) {
        if tap {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !tap
        passwordTextField.isEnabled = !tap
        loginButton.isEnabled = !tap
        signUpButton.isEnabled = !tap
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: "Wrong email or password! " + message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
        
        setLogin(false)
        emailTextField.text = ""
        passwordTextField.text = ""
    }


}

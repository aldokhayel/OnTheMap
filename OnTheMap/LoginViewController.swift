//
//  ViewController.swift
//  OnTheMap
//
//  Created by Abdulrahman on 21/12/2018.
//  Copyright © 2018 Abdulrahman. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.borderStyle = .roundedRect
        passwordTextField.borderStyle = .roundedRect
        loginButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc private func addLocation(_ sender: Any){
        let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddLocationNavigationController") as! UINavigationController
        present(navController, animated: true, completion: nil)
    }
    
    @IBAction func loginTapped(_ sender: Any){

        fieldsChecker()
        API.login(emailTextField.text!, passwordTextField.text!) {(successful, error) in
            DispatchQueue.main.async {
                // for any error not expeceted
                if let error = error {
                    print(error.localizedDescription)
                    let errorAlert = UIAlertController(title: "Error", message: "There is error", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                        return
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }
                
                // for invalid email or password
                if !successful {
                    let invalidAccessAlert = UIAlertController(title: "Invalid Access", message: "Invalid email or password", preferredStyle: .alert)
                    invalidAccessAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                        return
                    }))
                    self.present(invalidAccessAlert, animated: true, completion: nil)
                } else {
                // move to next storyboard
                let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                //self.navigationController!.pushViewController(mapVC, animated: true)
                self.present(mapVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        guard let url = URL(string: "https://www.udacity.com/account/auth#!/signup") else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func fieldsChecker(){
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!  {
            let alert = UIAlertController(title: "Fill the auth info", message: "Please fill both email and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                return
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}



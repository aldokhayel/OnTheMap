//
//  ViewController.swift
//  OnTheMap
//
//  Created by Abdulrahman on 21/12/2018.
//  Copyright © 2018 Abdulrahman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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

    @IBAction func signup(_ sender: Any) {
        guard let url = URL(string: "https://www.udacity.com/account/auth#!/signup") else {
            self.dispalyError("could not open the website")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {

        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard (error == nil) else {
                //completionHandlerForAuth(false, error?.localizedDescription)
                return
            }

                guard let data = data else {
                    self.dispalyError("there is no data")
                    return
                }
                guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                    self.dispalyError("the status code > 2xx")
                    return
                }
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */

            do {
                let decoder = JSONDecoder()
                let dataDecoded = try decoder.decode(loginResponse.self, from: newData)
                let accountID = dataDecoded.account.key
                let accountRegister = dataDecoded.account.registered
                let sessionID = dataDecoded.session.id
                let sessionExpire = dataDecoded.session.expiration
                print(":: Authentication Information ::")
                print("--------------------------")
                print("The account ID: \(String(describing: accountID!))")
                print("The account Registered: \(String(describing: accountRegister!))")
                print("The session ID: \(String(describing: sessionID!))")
                print("The seesion expire: \(String(describing: sessionExpire!))")
                print("--------------------------\n")
            } catch let error {
                self.dispalyError("could not decode data \(error.localizedDescription)")
                return
            }
            print("The login is done successfuly!")
        }
        task.resume()
        
    }
    
    private func dispalyError(_ error: String){
        print(error)
    }
}


//
//  HeaderViewController.swift
//  OnTheMap
//
//  Created by Abdulrahman on 30/12/2018.
//  Copyright © 2018 Abdulrahman. All rights reserved.
//

import UIKit

class HeaderViewController: UIViewController {

    var studentLocation: [StudentLocation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addLocation(_:)))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refresh(_:)))
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logout(_:)))
        self.navigationItem.rightBarButtonItems = [add, refresh]
        self.navigationItem.leftBarButtonItem = logout
    }
    
    @objc private func addLocation(_ sender: Any){
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationNavigationController") as! UINavigationController
        self.present(mapVC, animated: true, completion: nil)
    }
    
    @objc private func refresh(_ sender: Any){
        API.shared.getStudentsLocations { (result, error) in
            guard let result = result else {
                return
            }
            guard result.count != 0 else{
                return
            }
            self.studentLocation = result
        }
    }
    
    @objc private func logout(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
}

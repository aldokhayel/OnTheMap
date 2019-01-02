//
//  ActivityIndicator.swift
//  OnTheMap
//
//  Created by Abdulrahman on 02/01/2019.
//  Copyright © 2019 Abdulrahman. All rights reserved.
//

import Foundation
import UIKit

struct ActivityIndicator {
    
    private static var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    static func startActivityIndicator(view:UIView){
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    
    static func stopActivityIndicator(){
        activityIndicator.stopAnimating()
    }
    
}

//
//  StudentsLocations.swift
//  OnTheMap
//
//  Created by Abdulrahman on 24/12/2018.
//  Copyright © 2018 Abdulrahman. All rights reserved.
//

import Foundation
import UIKit

struct Result: Codable {
    let results: [StudentLocation]?
}

struct StudentLocation: Codable {
    static var lastFetched: [StudentLocation]?
    
    let createdAt : String?
    let firstName : String?
    let lastName : String?
    let latitude : Double?
    let longitude : Double?
    let mapString : String?
    let mediaURL : String?
    let objectId : String?
    let uniqueKey : String?
    let updatedAt : String?
}

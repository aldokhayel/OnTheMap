//
//  StudentsLocations.swift
//  OnTheMap
//
//  Created by Abdulrahman on 24/12/2018.
//  Copyright © 2018 Abdulrahman. All rights reserved.
//

import Foundation
import UIKit

struct result: Codable {
    let results: [Results]
}

struct Results: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}

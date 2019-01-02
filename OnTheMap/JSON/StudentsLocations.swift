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
    var createdAt : String?
    var firstName : String?
    var lastName : String?
    var latitude : Double?
    var longitude : Double?
    var mapString : String?
    var mediaURL : String?
    var objectId : String?
    var uniqueKey : String?
    var updatedAt : String?
}


extension StudentLocation {
    init(mapString: String, mediaURL: String) {
        self.mapString = mapString
        self.mediaURL = mediaURL
    }
}

enum Param: String {
    case updatedAt
}

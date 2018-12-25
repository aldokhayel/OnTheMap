//
//  Authentication.swift
//  OnTheMap
//
//  Created by Abdulrahman on 22/12/2018.
//  Copyright © 2018 Abdulrahman. All rights reserved.
//

import Foundation
import UIKit

struct loginRequest: Codable {
    let email: String
    let password: String
}

struct loginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool?
    let key: String?
}

struct Session: Codable {
    let id: String?
    let expiration: String?
}

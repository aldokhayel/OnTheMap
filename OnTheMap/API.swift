//
//  API.swift
//  OnTheMap
//
//  Created by Abdulrahman on 24/12/2018.
//  Copyright © 2018 Abdulrahman. All rights reserved.
//

import Foundation

class API {
    
    static func login(_ email: String,_ password: String, completion: @escaping (Bool, Error?)->()) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            func dispalyError(_ error: String){
                print(error)
            }
            
            guard (error == nil) else {
                completion (false, error)
                return
            }
            
            guard let data = data else {
                dispalyError("there is no data")
                return
            }
            guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                dispalyError("the status code > 2xx")
                completion (false, error)
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
                print("The account registered: \(String(describing: accountRegister!))")
                print("The session ID: \(String(describing: sessionID!))")
                print("The seesion expire: \(String(describing: sessionExpire!))")
                print("--------------------------\n")
                completion (true, nil)
                print("The login is done successfuly!")
            } catch let error {
                dispalyError("could not decode data \(error.localizedDescription)")
                completion (false, nil)
                return
            }
        }
        task.resume()
        
        
    }
    
    private func dispalyError(_ error: String){
        print(error)
    }
    
    static func getStudentsLocations(completion: @escaping ([StudentLocation]?, Error?)->()){
        
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error
                completion(nil, error)
                return
            }
            guard let data = data else {
                print("data issue")
                completion(nil, error)
                return
            }
            guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                print("response error")
                completion(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let result = try! decoder.decode(Result.self, from: data)
                completion(result.results, nil)
            } catch let error {
                print("there is error in decoding data\n")
                print(error.localizedDescription)
            }
            //print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
}

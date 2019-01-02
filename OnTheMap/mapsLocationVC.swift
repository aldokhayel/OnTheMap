//
//  mapsLocationVC.swift
//  OnTheMap
//
//  Created by Abdulrahman on 01/01/2019.
//  Copyright © 2019 Abdulrahman. All rights reserved.
//

import UIKit
import MapKit

class mapsLocationVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    static let shared = mapsLocationVC()
    var location: StudentLocation?
    var selectedLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var locationTitle = ""
    var url = ""
    
    var mapString:String?
    var mediaURL:String?
    var latitude:Double?
    var longitude:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n-------------")
        print(":: view Did Load ::")
        print("selectedLocation: \(selectedLocation)")
        print("locationTitle: \(locationTitle)")
        print("url: \(url)")
        mapView.delegate = self
        //self.loadPin()
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel(_:)))
        self.navigationItem.leftBarButtonItem = cancel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        createAnnotation()
    }
    
    func createAnnotation(){
        let annotation = MKPointAnnotation()
        annotation.title = mapString!
        annotation.subtitle = mediaURL!
        annotation.coordinate = CLLocationCoordinate2DMake(latitude ?? 0.0, longitude ?? 0.0)
        self.mapView.addAnnotation(annotation)
        
        
        //zooming to location
        let coredinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude ?? 0.0, longitude ?? 0.0)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coredinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
    }
    
    @objc private func cancel(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    func loadPin() {
        //DispatchQueue.main.async {
        // DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.selectedLocation
        annotation.title = self.locationTitle
        print("\n-------------------------")
                print(":: Load Pin ::")
                print("annotation.coordinate \(selectedLocation.latitude, selectedLocation.longitude)")
                print("annotation.title: \(locationTitle)")
        //if self.selectedLocation.latitude != 0.0 && self.selectedLocation.longitude != 0.0 {
        
        self.mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: self.selectedLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        //  }
        //}
    }
    
    @IBAction func finishTapped(_ sender: Any) {
        API.shared.getUser { (success, student, errorMessage) in
            if success {
                print("student?.uniqueKey: \(student?.uniqueKey)")
                DispatchQueue.main.async {
                    self.sendInformation(student!)
                }
            } else {
                DispatchQueue.main.async {
                    print(errorMessage)
                }
            }
        }
        print("finish tapped")
//        DispatchQueue.main.async {
//            if let navigationController = self.navigationController {
//                navigationController.popToRootViewController(animated: true)
//            }
//        }
    }
    
    func sendInformation(_ student: StudentLocation){
        var newStudent = StudentLocation()
        newStudent.uniqueKey = student.uniqueKey
        newStudent.firstName = student.firstName
        newStudent.lastName = student.lastName
        newStudent.mapString = student.mapString
        newStudent.mediaURL = student.mediaURL
        newStudent.longitude = student.longitude
        newStudent.latitude = student.latitude
        API.shared.postStudent(newStudent) { (success, errorMessage) in
            if success {
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    print(errorMessage)
                }
            }
        }
    }
    
//    func postNewStudentLocation(){
//
//        if let nickname = OTMUdacityClient.sharedInstance().nickname {
//            var components = nickname.components(separatedBy: " ")
//            if(components.count > 0)
//            {
//                let firstName = components.removeFirst()
//                let lastName = components.joined(separator: " ")
//
//
//                let jsonBody = StudentLocationsBody(uniqueKey:OTMUdacityClient.sharedInstance().userID! , firstName:firstName, lastName:lastName ,mapString:mapString!,mediaURL:mediaURL! ,latitude:latitude! , longitude:longitude!)
//
//
//                OTMParseClient.sharedInstance().postUserLocation(jsonBody: jsonBody) { (success, errorString) in
//
//                    if success {
//                        print(success)
//
//                        self.returnBackToRoot()
//
//                    }else {
//                        Alert.showBasicAlert(on: self, with: errorString!.localizedCapitalized)
//                    }
//
//                }
//            }
//
//        }
//
//
//    }
}


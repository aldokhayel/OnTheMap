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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n-------------")
        print(":: view Did Load ::")
        print("selectedLocation: \(selectedLocation)")
        print("locationTitle: \(locationTitle)")
        print("url: \(url)")
        mapView.delegate = self
        self.loadPin()
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel(_:)))
        self.navigationItem.leftBarButtonItem = cancel
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
                DispatchQueue.main.async {
                    self.sendInformation(student!)
                }
            } else {
                DispatchQueue.main.async {
                    print(errorMessage)
                }
            }
        }
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
}


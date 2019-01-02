//
//  MapLocationViewController.swift
//  OnTheMap
//
//  Created by Abdulrahman on 31/12/2018.
//  Copyright © 2018 Abdulrahman. All rights reserved.
//

import UIKit
import MapKit

class MapLocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    //let mapView = MKMapView()
    @IBOutlet weak var finishButton: UIButton!
    var location: StudentLocation?
    var selectedLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var locationTitle = ""
    var url = ""
    // let postingMap = PostingMap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupMap()
        //mapView.delegate = self
        self.setMapView()
        //self.loadPin()
    }
    override func viewWillAppear(_ animated: Bool) {
        API.shared.getStudentsLocations(){(result, error) in
            DispatchQueue.main.async {
                if error != nil {
                    let alert = UIAlertController(title: "Fail", message: "sorry, we could not fetch data", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    print("error")
                    return
                }
                
                guard result != nil else {
                    let alert = UIAlertController(title: "Fail", message: "sorry, we could not fetch data", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    return
                }
                
                StudentLocation.lastFetched = result
                var map = [MKPointAnnotation]()
                
                for location in result! {
                    let long = CLLocationDegrees(location.longitude ?? 0.0)
                    let lat = CLLocationDegrees(location.latitude ?? 0.0)
                    let cords = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let mediaURL = location.mediaURL ?? " "
                    let firstName = location.firstName ?? " "
                    let lastName = location.lastName ?? " "
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = cords
                    annotation.title = "\(firstName) \(lastName)"
                    annotation.subtitle = mediaURL
                    map.append(annotation)
                }
                self.mapView.addAnnotations(map)
            }
        }
    }
    
    @IBAction func finish(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadPin() {
        //DispatchQueue.main.async {
//            let long = CLLocationDegrees(selectedLocation.longitude )
//            let lat = CLLocationDegrees(selectedLocation.latitude )
//            let cords = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
            let annotation = MKPointAnnotation()
            annotation.coordinate = selectedLocation
            annotation.title = locationTitle
            print("\n-------------------------")
            print("annotation.coordinate \(selectedLocation.latitude, selectedLocation.longitude)")
            print("annotation.title: \(locationTitle)")
            print(mapView)
            mapView.addAnnotation(annotation)
            let region = MKCoordinateRegion(center: self.selectedLocation, latitudinalMeters: 4000, longitudinalMeters: 4000)
            mapView.setRegion(region, animated: true)
        //}
    }
    
    func setMapView() {
//        let leftMargin: CGFloat = 0
//        let topMargin: CGFloat = 0
//        let mapWidth: CGFloat = view.frame.size.width
//        let mapHeight: CGFloat = view.frame.size.height
//
//
//        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
//        mapView.mapType = MKMapType.standard
//        mapView.isZoomEnabled = true
//        mapView.isScrollEnabled = true
//        mapView.center = view.center
        
//        let xPostion:CGFloat = 25
//        let yPostion:CGFloat = mapHeight - 100
//        let buttonHeight:CGFloat = 45
//        finishButton.addTarget(self, action: #selector(prepareInformation), for: .touchUpInside)
//        finishButton.frame = CGRect(x:xPostion, y:yPostion, width:mapWidth - 50, height:buttonHeight)

//        let cancelButton = postingMap.cancelButton()
//        cancelButton.target = self
//        cancelButton.action = #selector(self.cancel)

//        self.navigationItem.leftBarButtonItem = cancelButton
//        self.navigationItem.title = postingMap.title
//        self.mapView.addSubview(finishButton)
        self.view = self.mapView
    }

    @objc func prepareInformation(){
        API.shared.getUser(){ (success, student, errorMessage) in
            if success {
                DispatchQueue.main.async {
                    self.sendInformation(student!)
                }
            } else {
                DispatchQueue.main.async {
                    //self.displayNotification(errorMessage!)}
            }
        }
    }
}
    func sendInformation(_ student: StudentLocation){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //if Storage.objectId == "" { //post new student
            API.shared.postStudent(student){ (success, errorMessage) in
                if success {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        //self.displayNotification(errorMessage!)}
                }
            }
//        } else { //put update student
//            ParseClient.sharedInstance.putStudent(prepStudent){ (success, errorMessage) in
//                if success {
//                    DispatchQueue.main.async {
//                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                        self.complete()
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                        self.displayNotification(errorMessage!)}
//                }
//            }
//        }
    }
    
    }
    
    func setupMap() {
        guard let location = location else { return }
        
        let lat = CLLocationDegrees(location.latitude!)
        let long = CLLocationDegrees(location.longitude!)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location.mapString
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }

}

extension MapLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!,
                let url = URL(string: toOpen), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}


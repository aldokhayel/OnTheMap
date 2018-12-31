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
    var location: StudentLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func finish(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupMap() {
        guard let location = location else { return }
        
        let lat = CLLocationDegrees(location.latitude!)
        let long = CLLocationDegrees(location.longitude!)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        // TODO: Create a new MKPointAnnotation
        let annotation = MKPointAnnotation()
        // TODO: Set annotation's `coordinate` and `title` properties to the correct coordinate and `location.mapString` respectively
        annotation.coordinate = coordinate
        annotation.title = location.mapString
        // TODO: Add annotation to the `mapView`
        mapView.addAnnotation(annotation)
        
        // Setting current mapView's region to be centered at the pin's coordinate
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }

}

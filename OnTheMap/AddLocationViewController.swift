//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Abdulrahman on 30/12/2018.
//  Copyright © 2018 Abdulrahman. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {

    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var mediaURL: UITextField!
    @IBOutlet weak var findLocation: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationName.borderStyle = .roundedRect
        mediaURL.borderStyle = .roundedRect
        findLocation.layer.cornerRadius = 5
    }
    
    
    @IBAction func findLocationButton(_ sender: Any) {
        guard let locationName = locationName.text, let mediaURL = mediaURL.text, locationName != "", mediaURL != "" else {
            return
        }
        let studentLocation = StudentLocation(mapString: locationName, mediaURL: mediaURL)
            gecodeCoordinates(studentLocation)
    }
    
    func startAnActivityIndicator() -> UIActivityIndicatorView {
        let ai = UIActivityIndicatorView(style: .gray)
        self.view.addSubview(ai)
        self.view.bringSubviewToFront(ai)
        ai.center = self.view.center
        ai.hidesWhenStopped = true
        ai.startAnimating()
        return ai
    }
    
    func gecodeCoordinates(_ studentLocation: StudentLocation){
        let ai = self.startAnActivityIndicator()
        CLGeocoder().geocodeAddressString(studentLocation.mapString!) { (placeMarks, error) in
            ai.stopAnimating()
            guard let firstLocation = placeMarks?.first?.location else {return}
            
            var location = studentLocation
            location.longitude = firstLocation.coordinate.longitude
            location.latitude = firstLocation.coordinate.latitude
            self.performSegue(withIdentifier: "mapLocation", sender: location)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

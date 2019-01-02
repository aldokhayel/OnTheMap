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
    var newLocation = StudentLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationName.delegate = self
        mediaURL.delegate = self
        locationName.borderStyle = .roundedRect
        mediaURL.borderStyle = .roundedRect
        findLocation.layer.cornerRadius = 5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel(_:)))
        self.navigationItem.leftBarButtonItem = cancel
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    @IBAction func findLocationButton(_ sender: Any) {
        guard let locationName = locationName.text, let mediaURL = mediaURL.text, locationName != "", mediaURL != "" else {
            return
        }
        let studentLocation = StudentLocation(mapString: locationName, mediaURL: mediaURL)
            gecodeCoordinates(studentLocation)
    }
    
    @objc private func cancel(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    //_ studentLocation: StudentLocation
    func gecodeCoordinates(_ studentLocation: StudentLocation){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let ai = self.startAnActivityIndicator()

        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //let ai = self.startAnActivityIndicator()
        
        CLGeocoder().geocodeAddressString(studentLocation.mapString!) { (placeMarks, error) in
            //DispatchQueue.main.async {
            //DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {

            ai.stopAnimating()
            if error != nil {
                print(error?.localizedDescription ?? " ")
                return
            }
            guard let placeMarks = placeMarks else {
                print("unable to find locatoin")
                return
            }
            print("placeMarks: \(placeMarks)")
            print("placeMarks.first?.location?.coordinate: \(String(describing: placeMarks.first?.location?.coordinate))")
            if placeMarks.count <= 0 {
                print("placeMarks is lower than zero!")
                return
            }
            //guard let firstLocation = placeMarks?.first?.location else {return}
//            var location = studentLocation
//            location.longitude = firstLocation.coordinate.longitude
//            location.latitude = firstLocation.coordinate.latitude
            let selectedLocation = placeMarks.first?.location?.coordinate
//            let newMap = mapsLocationVC()
//            newMap.selectedLocation = selectedLocation!
//            newMap.locationTitle = studentLocation.mapString!
//            newMap.url = self.mediaURL.text!
//            print("selectedLocation: \(newMap.selectedLocation)")
//            print("title: \(newMap.locationTitle)")
//            print("url: \(newMap.url)")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            self.newLocation = studentLocation
            self.newLocation.latitude = selectedLocation?.latitude
            self.newLocation.longitude = selectedLocation?.longitude
            //print("long2: \(self.newLocation.longitude)")
            //self.navigationController?.pushViewController(newMap, animated: true)
            self.performSegue(withIdentifier: "mapsLocation", sender: self.newLocation)
            //let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "mapsLocation") as! UIViewController
            //self.navigationController!.pushViewController(newMap, animated: true)
            //self.present(mapVC, animated: true, completion: nil)
            //}
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapsLocation", let vc = segue.destination as? mapsLocationVC {
            print("long2:: \(self.newLocation.longitude)")
            vc.selectedLocation = CLLocationCoordinate2D(latitude: self.newLocation.latitude ?? 0.0, longitude: self.newLocation.longitude ?? 0.0)
            vc.locationTitle = self.newLocation.mapString ?? " "
            vc.url = self.newLocation.mediaURL ?? ""
//            vc.selectedLocation.latitude = self.newLocation.latitude!
//            vc.selectedLocation.longitude = self.newLocation.longitude!
//            vc.location = (sender as! StudentLocation)
//            vc.url = (sender as! StudentLocation).mediaURL!
            //vc.location =
            
           
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "mapLocation", let vc = segue.destination as? MapLocationViewController {
//            vc.location = (sender as! StudentLocation)
//        }
//    }
}

extension AddLocationViewController: UITextFieldDelegate {
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = -findLocation.frame.origin.y+50
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
}

private extension AddLocationViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}


//extension UIViewController {
//    func startAnActivityIndicator() -> UIActivityIndicatorView {
//        let ai = UIActivityIndicatorView(style: .gray)
//        self.view.addSubview(ai)
//        self.view.bringSubviewToFront(ai)
//        ai.center = self.view.center
//        ai.hidesWhenStopped = true
//        ai.startAnimating()
//        return ai
//    }
//}

extension UIViewController {
    func startAnActivityIndicator() -> UIActivityIndicatorView {
        let ai = UIActivityIndicatorView(style: .gray)
        self.view.addSubview(ai)
        self.view.bringSubviewToFront(ai)
        ai.center = self.view.center
        ai.hidesWhenStopped = true
        ai.startAnimating()
        return ai
    }
}

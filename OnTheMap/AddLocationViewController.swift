//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Abdulrahman on 30/12/2018.
//  Copyright © 2018 Abdulrahman. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var mediaURL: UITextField!
    @IBOutlet weak var findLocation: UIButton!
    var newLocation = StudentLocation()
    var latitude : Double?
    var longitude : Double?
    
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
    
    @objc private func cancel(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationButton(_ sender: Any) {
        if locationName.text != "" && mediaURL.text != "" {
            ActivityIndicator.startActivityIndicator(view: self.view )
            
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = locationName.text
            
            let activeSearch = MKLocalSearch(request: searchRequest)
            
            activeSearch.start { (response, error) in
                DispatchQueue.main.async {
                    
                    if error != nil {
                        ActivityIndicator.stopActivityIndicator()
                        print("Location Error : \(error!.localizedDescription)")
                    }else {
                        ActivityIndicator.stopActivityIndicator()
                        
                        self.latitude = response?.boundingRegion.center.latitude
                        self.longitude = response?.boundingRegion.center.longitude
                        
                        self.performSegue(withIdentifier: "showLocation", sender: nil)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                
                print("error")
            }
        }
    }
    
    func gecodeCoordinates(_ studentLocation: StudentLocation){
        
        let ai = self.startAnActivityIndicator()
        CLGeocoder().geocodeAddressString(studentLocation.mapString!) { (placeMarks, error) in
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
            
            let selectedLocation = placeMarks.first?.location?.coordinate
            self.newLocation = studentLocation
            self.newLocation.latitude = selectedLocation?.latitude
            self.newLocation.longitude = selectedLocation?.longitude
            self.performSegue(withIdentifier: "mapsLocation", sender: self.newLocation)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLocation" {
            let vc = segue.destination as! mapsLocationVC
            vc.mapString = locationName.text!
            vc.mediaURL = mediaURL.text!
            vc.latitude = self.latitude
            vc.longitude = self.longitude
        }
    }
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

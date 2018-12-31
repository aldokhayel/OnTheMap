//
//  StudentsTableViewController.swift
//  OnTheMap
//
//  Created by Abdulrahman on 25/12/2018.
//  Copyright © 2018 Abdulrahman. All rights reserved.
//

import UIKit

class StudentsTableViewController: HeaderViewController {
    
    var result = [StudentLocation]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        tableView.delegate = self
        tableView.dataSource = self
        result = StudentLocation.lastFetched ?? []
    }
}

extension StudentsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("counting ...")
        print(result.count)
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell") as! DataViewCell
        let student = self.result[(indexPath).row]
        cell.name.text = "\(student.firstName ?? " ")  \(student.lastName ?? " ")"
        cell.mediaURL.text = student.mediaURL
        return cell
    }
}

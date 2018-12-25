//
//  StudentsTableViewController.swift
//  OnTheMap
//
//  Created by Abdulrahman on 25/12/2018.
//  Copyright © 2018 Abdulrahman. All rights reserved.
//

import UIKit

class StudentsTableViewController: UITableViewController {
    
    //var result = [Results]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        print("view Will Appear")
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 100
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("here in table view")
        API.getStudentsLocations(){(result, error) in
            DispatchQueue.main.async {
                
                if error != nil {
                    print("error")
                    return
                }
                
                guard result != nil else {
                    return
                }
                print("inside async")
                for location in result! {
                    let mediaURL = location.mediaURL
                    let firstName = location.firstName
                    let lastName = location.lastName
                    print(location.firstName)
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableStudentCell")!
                //let student = self.result[(indexPath as IndexPath).row]
                let student = result![(indexPath as IndexPath).row]
                cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
                cell.detailTextLabel?.text = student.mediaURL
                //return cell

            }
        }
        return UITableViewCell()
    }
        
        
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

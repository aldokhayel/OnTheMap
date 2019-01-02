//
//  DataViewCell.swift
//  OnTheMap
//
//  Created by Abdulrahman on 27/12/2018.
//  Copyright © 2018 Abdulrahman. All rights reserved.
//

import UIKit

class DataViewCell: UITableViewCell {
    
    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mediaURL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

//
//  AssignmentCell.swift
//  Course
//
//  Created by Archie Yu on 2016/11/20.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit

class AssignmentCell : UITableViewCell {
    
    @IBOutlet weak var course: UILabel!
    @IBOutlet weak var assignment: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var card: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//
//  AssignmentCell.swift
//  Course
//
//  Created by Archie Yu on 2017/1/10.
//  Copyright © 2017年 Archie Yu. All rights reserved.
//

import UIKit

class WeekAssignmentCell: UITableViewCell {
    
    @IBOutlet weak var assignmentContent: UILabel!
    @IBOutlet weak var assignmentTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

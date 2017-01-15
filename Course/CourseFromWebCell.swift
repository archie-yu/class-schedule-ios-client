//
//  CourseFromWebCell.swift
//  Course
//
//  Created by Archie Yu on 2017/1/15.
//  Copyright © 2017年 Archie Yu. All rights reserved.
//

import UIKit

class CourseFromWebCell: UITableViewCell {

    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

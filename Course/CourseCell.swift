//
//  CourseCell.swift
//  Course
//
//  Created by Archie Yu on 2016/12/12.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell {
    
    @IBOutlet weak var CourseName: UILabel!
    @IBOutlet weak var CourseTime: UILabel!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var TeacherName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

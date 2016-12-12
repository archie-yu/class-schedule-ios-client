//
//  AssignmentDetailViewController.swift
//  Course
//
//  Created by Archie Yu on 2016/12/4.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit

class AssignmentDetailViewController : UIViewController {
    
    var courseName = ""
    var assignmentNo = -1
    
    @IBOutlet weak var assignmentContent: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
//        courseNameLabel.text = courseName
        self.title = assignmentList[assignmentNo].courseName
        assignmentContent.text = assignmentList[assignmentNo].content
    }
    
    @IBAction func checkRemainingTime(_ sender: Any) {
        
    }
    
}

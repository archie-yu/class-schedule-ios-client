//
//  CourseInformationViewController.swift
//  Course
//
//  Created by Archie Yu on 2017/1/24.
//  Copyright © 2017年 Archie Yu. All rights reserved.
//

import UIKit

class CourseInformationViewController: UIViewController {

    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var timeAndLocationLabel: UILabel!
    @IBOutlet weak var teacherTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

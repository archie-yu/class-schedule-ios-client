//
//  DisplayCoursesViewController.swift
//  Course
//
//  Created by Cedric on 2016/12/8.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit
import CourseModel

class DisplayCoursesViewController: UITableViewController {
    
    var weekday = 0
    
    @IBOutlet weak var courseTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        courseTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return everydayCourseList[weekday].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as! CourseCell
        
        cell.selectionStyle = .none
        
        let course = everydayCourseList[weekday][indexPath.row]
        cell.CourseName.text = course.course
        cell.CourseTime.text = "\(course.begin) - \(course.end)"
        cell.Location.text = course.location
        cell.TeacherName.text = course.teacher
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64)
        let header = UIView(frame: rect)
        header.backgroundColor = UIColor(white: 0, alpha: 0)
        return header
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let identifier = segue.identifier {
            switch(identifier) {
            case "ShowCourseDetail":
                let controller = segue.destination as! CourseDetailViewController
                controller.weekday = weekday
                controller.courseNo = (courseTable.indexPathForSelectedRow?.row)!
            default: break
            }
        }

    }
}

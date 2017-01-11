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
    
    @IBOutlet weak var courseCell: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        courseCell.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWeekday() -> Int{
        return weekday
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
        return everydayCourseList[weekday - 1].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCellID", for: indexPath) as! CourseCell
        
        let course = everydayCourseList[weekday - 1][indexPath.row]
        cell.CourseName.text = course.course
        cell.CourseTime.text = "\(course.begin)-\(course.end)"
        cell.Location.text = course.location
        
        return cell
        
    }
    
}

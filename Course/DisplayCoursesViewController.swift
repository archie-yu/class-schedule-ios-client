//
//  DisplayCoursesViewController.swift
//  Course
//
//  Created by Cedric on 2016/12/8.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit

class DisplayCoursesViewController: UITableViewController {
    
    var dayID = 0
    
    var numCourses = 0;
    
    var thisdaycourseList : [CourseModel] = []
    
    @IBOutlet weak var courseCell: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getdayID()->Int{
        return dayID
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
        return numCourses
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCellID", for: indexPath) as! CourseCell
        
        //print(indexPath.row)
        
        cell.CourseName.text = thisdaycourseList[indexPath.row].courseName
        cell.TeacherName.text = thisdaycourseList[indexPath.row].teacherName
        cell.Location.text = thisdaycourseList[indexPath.row].location
        
        return cell;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        courseCell.reloadData()
    }
    
    public func addCourse(course:CourseModel){
        
        thisdaycourseList.append(course)
        
        numCourses += 1
        
        //print(numCourses)
        
    }
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (self.view as! UITableView).reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonList[weekday].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as! CourseCell
        
        cell.selectionStyle = .none
        
        let lesson = lessonList[weekday][indexPath.row]
        cell.CourseName.text = lesson.course
        cell.CourseTime.text = "\(lesson.firstClass) - \(lesson.lastClass)"
        cell.Location.text = lesson.room
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 84
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64)
        let header = UIView(frame: rect)
        header.backgroundColor = UIColor(white: 0, alpha: 0)
        return header
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 84)
        let footer = UIView(frame: rect)
        footer.backgroundColor = UIColor(white: 0, alpha: 0)
        return footer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let identifier = segue.identifier {
            switch(identifier) {
            case "ShowCourseDetail":
                let controller = segue.destination as! CourseDetailViewController
                controller.weekday = weekday
                controller.lessonNo = ((self.view as! UITableView).indexPathForSelectedRow?.row)!
            default: break
            }
        }

    }
}

//
//  CourseFromWebViewController.swift
//  Course
//
//  Created by Archie Yu on 2017/1/15.
//  Copyright © 2017年 Archie Yu. All rights reserved.
//

import UIKit
import CourseModel

class CourseFromWebViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        courseFromWebList.removeAll()
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        for i in 0..<courseFromWebList.count {
            let indexPath = IndexPath(row: i, section: 0)
            if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                let course = courseFromWebList[i]
                add(course: course)
                for lesson in lessonFromWebList[i] {
                    add(lesson: lesson)
                }
            }
        }
        courseFromWebList.removeAll()
        lessonFromWebList.removeAll()
        let filePath = courseDataFilePath()
        NSKeyedArchiver.archiveRootObject(courseList, toFile: filePath)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseFromWebList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseFromWebCellID", for: indexPath) as! CourseFromWebCell

        let course = courseFromWebList[indexPath.row]
        cell.courseLabel.text = course.course
        cell.teacherLabel.text = course.teacher
        var lessonString = ""
        for lesson in lessonFromWebList[indexPath.row] {
            lessonString += "\(lesson.room), \(weekdayStrings[lesson.weekday]) \(lesson.firstClass)-\(lesson.lastClass)节; "
        }
        cell.locationLabel.text = lessonString.substring(to: lessonString.index(lessonString.endIndex, offsetBy: -2))

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
        }
        
    }

}

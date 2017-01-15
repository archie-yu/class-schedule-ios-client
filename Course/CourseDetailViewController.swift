//
//  CourseDetailViewController.swift
//  Course
//
//  Created by Cedric on 2017/1/13.
//  Copyright © 2017年 Archie Yu. All rights reserved.
//

import UIKit
import CourseModel

class CourseDetailViewController: UIViewController ,UITextViewDelegate,UITextFieldDelegate{
    var weekday = -1
    var courseNo = -1
    var courseName = ""
    let weekdays = ["周一","周二","周三","周四","周五"]
    
    @IBOutlet weak var teachernameField: UITextField!
    @IBOutlet weak var weekdayField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    
    @IBOutlet weak var coursenameLabel: UILabel!
    
    @IBOutlet weak var courseDetails: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        timeField.isEnabled = false
        weekdayField.isEnabled = false
        
        courseDetails.delegate = self
        locationField.delegate = self
        teachernameField.delegate = self
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        let course = everydayCourseList[weekday][courseNo]
        courseName = course.course
        
        coursenameLabel.text = courseName
        teachernameField.text = course.teacher
        weekdayField.text = weekdays[course.weekday - 1]
        locationField.text = course.location
        timeField.text = String(course.begin) + "-" + String(course.end) + "节"
        if course.courseDetails != ""{
            courseDetails.text = course.courseDetails
        }
        
    }
    

    @IBAction func TeacherNameModified(_ sender: UITextField) {
        everydayCourseList[weekday][courseNo].teacher = teachernameField.text!
        let course = everydayCourseList[weekday][courseNo]
        let index = courseList.index(of: course)
        courseList[index!].teacher = teachernameField.text!
        
        let filePath = courseDataFilePath()
        NSKeyedArchiver.archiveRootObject(courseList, toFile: filePath)
    }
    
    
    @IBAction func LocationModified(_ sender: UITextField) {
        everydayCourseList[weekday][courseNo].location = locationField.text!
        let course = everydayCourseList[weekday][courseNo]
        let index = courseList.index(of: course)
        courseList[index!].location = locationField.text!
        
        let filePath = courseDataFilePath()
        NSKeyedArchiver.archiveRootObject(courseList, toFile: filePath)

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == courseDetails{
            if textView.text == "课程详细信息"{
                textView.text = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == courseDetails{
            if textView.text == ""{
                textView.text = "课程详细信息"
            }
            else{
                for course in courseList{
                    if course.course == courseName{
                        course.courseDetails = courseDetails.text
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        courseDetails.resignFirstResponder()
    }
    
    @IBAction func DeleteCourse(_ sender: UIButton) {
        
        //删除课程前 弹出警告框
        let alertController = UIAlertController(title: "删除课程", message: "删除后将不可恢复", preferredStyle:.actionSheet)
        
        // 设置2个UIAlertAction
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "删除", style: .destructive) {(alert: UIAlertAction) -> Void in
            
            let course = everydayCourseList[self.weekday][self.courseNo]
            let index = courseList.index(of: course)
            courseList.remove(at: index!)
            everydayCourseList[self.weekday].remove(at: self.courseNo)
            
            let filePath = courseDataFilePath()
            NSKeyedArchiver.archiveRootObject(courseList, toFile: filePath)
            
            self.navigationController?.popViewController(animated: true)
            
        }
        
        // 添加到UIAlertController
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        // 弹出
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

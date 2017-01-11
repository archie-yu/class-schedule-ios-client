//
//  AddCourseViewController.swift
//  Course
//
//  Created by Archie Yu on 2016/11/19.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit
import CourseModel

class AddCourseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let DAY_OF_WEEK = 5
    
    let LESSONS_A_DAY = 8
    
    let weekday = ["Mon","Tue","Wes","Thu","Fri"]
    
    @IBOutlet weak var CourseName: UITextField!
    
    @IBOutlet weak var PickerView: UIPickerView!
    
    @IBOutlet weak var Location: UITextField!
    
    @IBOutlet weak var TeacherName: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        PickerView.delegate = self
        
        PickerView.selectRow(0, inComponent: 0, animated: true)
        PickerView.selectRow(0, inComponent: 1, animated: true)
        PickerView.selectRow(1, inComponent: 2, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //set the col nums of the pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    //set the row nums of the pickerview
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return DAY_OF_WEEK
        case 1,2:
            return LESSONS_A_DAY
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        switch component {
        case 0:
            return weekday[row]
        case 1, 2:
            return String(row + 1)
        default:
            break
        }
        return nil
    }
    
    
    @IBAction func ReadyToTyping(_ sender: UITextField) {
        if CourseName.text == "请输入课程名"{
            CourseName.text = ""
        }
        
    }
    
    @IBAction func TypingEnded(_ sender: UITextField) {
        if CourseName.text == ""{
            CourseName.text = "请输入课程名"
        }
    }
    
    
    @IBAction func TeacherNameEnterBegin(_ sender: UITextField) {
        if TeacherName.text == "请输入老师姓名"{
            TeacherName.text = ""
        }
    }
    
    @IBAction func TeacherNameEnterEnded(_ sender: UITextField) {
        if TeacherName.text == ""{
            TeacherName.text = "请输入老师姓名"
        }
    }
    
    @IBAction func LocationEnterBegin(_ sender: UITextField) {
        if Location.text == "请输入地点"{
            Location.text = ""
        }
    }
    
    @IBAction func LocationEnterEnd(_ sender: UITextField) {
        if Location.text == ""{
            Location.text = "请输入地点"
        }
    }
    
    @IBAction func AddCourse(_ sender: UIBarButtonItem) {
        
        let course = CourseModel(course: CourseName.text!, teacher: TeacherName.text!, in: Location.text!,
                            on: PickerView.selectedRow(inComponent: 0) + 2,
                            from: PickerView.selectedRow(inComponent: 1) + 1,
                            to: PickerView.selectedRow(inComponent: 2) + 1)
        
        courseList.append(course)
        everydayCourseList[course.weekday - 2].append(course)
        
        let filePath = courseDataFilePath()
        NSKeyedArchiver.archiveRootObject(courseList, toFile: filePath)
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
}

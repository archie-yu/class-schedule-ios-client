//
//  AddCourseViewController.swift
//  Course
//
//  Created by Cedric on 2016/12/8.
//  Copyright © 2016年 Cedric. All rights reserved.
//

import UIKit
import CourseModel

class AddCourseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    
    let WEEKS_OF_TERM = 18
    
    let weekday = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    
    var editingItem = ""
    
    var deltaY : CGFloat = 0
    
    @IBOutlet weak var CourseName: UITextField!
    @IBOutlet weak var weekdayPickerView: UIPickerView!
    @IBOutlet weak var weekPickerView: UIPickerView!
    @IBOutlet weak var Location: UITextField!
    @IBOutlet weak var TeacherName: UITextField!
    
    @IBOutlet weak var NavigationBar: UINavigationBar!
    
    @IBOutlet weak var adjustableLayout: NSLayoutConstraint!
    @IBOutlet weak var locationLayout: NSLayoutConstraint!
    @IBOutlet weak var teachernameLayout: NSLayoutConstraint!
    @IBOutlet weak var coursenameLayout: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        weekdayPickerView.delegate = self
        weekPickerView.delegate = self
        
        weekdayPickerView.selectRow(0, inComponent: 0, animated: true)
        weekdayPickerView.selectRow(0, inComponent: 1, animated: true)
        weekdayPickerView.selectRow(1, inComponent: 2, animated: true)
        
        weekPickerView.selectRow(0, inComponent: 0, animated:true)
        weekPickerView.selectRow(weekNum - 1, inComponent: 1, animated:true)
        weekPickerView.selectRow(2, inComponent: 2, animated:true)
        
        CourseName.delegate = self
        Location.delegate = self
        TeacherName.delegate = self
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // 注册键盘出现和键盘消失的通知
        let NC = NotificationCenter.default
        NC.addObserver(self,
                       selector: #selector(AddCourseViewController.keyboardWillShow(notification:)),
                       name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NC.addObserver(self,
                       selector: #selector(AddCourseViewController.keyboardWillHide(notification:)),
                       name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 注销键盘出现和键盘消失的通知
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            // 计算可能需要上移的距离
            let keyboardHeight = keyboardFrame.origin.y
            switch(editingItem) {
            case "coursename":
                let coursenameHeight = CourseName.frame.maxY
                deltaY = keyboardHeight - coursenameHeight
                    break
            case "teachername":
                let teachernameHeight = TeacherName.frame.maxY
                deltaY = keyboardHeight - teachernameHeight
                break
            case "location":
                let locationHeight = Location.frame.maxY
                deltaY = keyboardHeight - locationHeight
                break
            default: break
            }
            
            // 需要上移时，变化视图位置
            if deltaY < 0 {
                self.view.bringSubview(toFront: NavigationBar)
                adjustableLayout.constant += deltaY
                UIView.animate(withDuration: 0.5, animations: {() -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }

    }
    
    func keyboardWillHide(notification: NSNotification) {
        // 还原视图位置
        if deltaY < 0{
            adjustableLayout.constant -= deltaY
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.view.layoutIfNeeded()
            })
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        if pickerView == weekdayPickerView{
            switch component {
            case 0:
                return weekdayNum
            case 1,2:
                return courseNum
            default:
                return 0
            }
        }
        else if pickerView == weekPickerView{
            switch component{
            case 0,1:
                return weekNum
            case 2:
                return 3
            default:
                return 0
            }
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if pickerView == weekdayPickerView{
            switch component {
            case 0:
                return weekday[row]
            case 1, 2:
                return String(row + 1)
            default:
                break
            }
        }
        else if pickerView == weekPickerView{
            switch component {
            case 0,1:
                return String(row + 1)
            case 2:
                if row == 0 {return "单周"}
                else if row == 1 {return "双周"}
                else if row == 2 {return "每周"}
            default:
                break;
            }
        }
        return nil
    }
    
    
    @IBAction func ReadyToTyping(_ sender: UITextField) {
        editingItem = "coursename"
        
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
        editingItem = "teachername"
        
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
        editingItem = "location"
        
        if Location.text == "请输入地点"{
            Location.text = ""
        }
    }
    
    @IBAction func LocationEnterEnd(_ sender: UITextField) {
        if Location.text == ""{
            Location.text = "请输入地点"
        }
    }
    
    func CheckContentIsLegal() -> Bool{
        let beginWeek = weekPickerView.selectedRow(inComponent: 0)
        let endWeek = weekPickerView.selectedRow(inComponent: 1)
        let beginLesson = weekdayPickerView.selectedRow(inComponent: 1)
        let endLesson = weekdayPickerView.selectedRow(inComponent: 2)
        
        if beginWeek > endWeek{
            let alertController = UIAlertController(title: "提示", message: "课程开始周不能晚于结束周", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
            return false

        }
        if beginLesson > endLesson{
            let alertController = UIAlertController(title: "提示", message: "课程开始时间不能晚于结束时间", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        if CourseName.text == "请输入课程名" {
            let alertController = UIAlertController(title: "提示", message: "未输入课程名！", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        if TeacherName.text == "请输入老师姓名"{
            let alertController = UIAlertController(title: "提示", message: "未输入老师姓名！", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        if Location.text == "请输入地点"{
            let alertController = UIAlertController(title: "提示", message: "未输入地点名！", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    @IBAction func AddCourse(_ sender: UIBarButtonItem) {
        if !CheckContentIsLegal(){
            return
        }
        
        let course = CourseModel(course: CourseName.text!, teacher: TeacherName.text!, in: Location.text!,
                            on: weekdayPickerView.selectedRow(inComponent: 0) + 1,
                            from: weekdayPickerView.selectedRow(inComponent: 1) + 1,
                            to: weekdayPickerView.selectedRow(inComponent: 2) + 1,
                            fromWeek: weekPickerView.selectedRow(inComponent: 0) + 1,toWeek: weekPickerView.selectedRow(inComponent: 1) + 1,limit: weekPickerView.selectedRow(inComponent: 2))
        
        for existedCourse in courseList{
            if existedCourse.course == course.course && existedCourse.courseDetails != ""{
                course.courseDetails = existedCourse.courseDetails
            }
        }
        courseList.append(course)
        everydayCourseList[course.weekday - 1].append(course)
        
        //courseList.removeAll()
        
        let filePath = courseDataFilePath()
        NSKeyedArchiver.archiveRootObject(courseList, toFile: filePath)
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
}

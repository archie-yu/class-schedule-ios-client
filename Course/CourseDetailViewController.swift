//
//  CourseDetailViewController.swift
//  Course
//
//  Created by Cedric on 2017/1/13.
//  Copyright © 2017年 Archie Yu. All rights reserved.
//

import UIKit
import CourseModel

class CourseDetailViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    var weekday = -1
    var lessonNo = -1
    var courseName = ""
    var count = 0
    var editingLine = -1
    
    var course: Course!
    
    var infoVC: CourseInformationViewController!
    
    var bgColor: UIColor!
    var courseTextField = UITextField()
    var roomTextFields: [UITextField] = []
    var timeButtons: [UIButton] = []
    var deleteButtons: [UIButton] = []
    var addButton = UIButton()
    var teacherTextField = UITextField()
    var deleteButtonState: [Bool] = []
    
    @IBOutlet weak var informationCard: UIView!
    @IBOutlet weak var notePlaceHolder: UILabel!
    @IBOutlet weak var courseDetails: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var infoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noteHeight: NSLayoutConstraint!
    
    func fillInformation() {
        infoVC.courseLabel.text = course.course
        var lessonString = ""
        for lesson in course.lessons {
            lessonString += "\(lesson.room), "
            switch lesson.alternate {
            case 1: lessonString += "单, "
            case 2: lessonString += "双, "
            default: break
            }
            lessonString += "\(weekdayStrings[lesson.weekday])\(lesson.firstClass)-\(lesson.lastClass)节; "
        }
        infoVC.timeAndLocationLabel.text = lessonString.substring(to: lessonString.index(lessonString.endIndex, offsetBy: -2))
        infoVC.teacherLabel.text = course.teacher
        courseDetails.text = course.note
    }
    
    func modify(textField: UITextField, withText text: String) -> CGFloat {
        textField.alpha = 0
        textField.tintColor = .white
        textField.textColor = .white
        textField.backgroundColor = bgColor
        textField.textAlignment = .center
        textField.text = text
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.returnKeyType = .done
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 6
        informationCard.addSubview(textField)
        informationCard.bringSubview(toFront: textField)
        textField.delegate = self
        textField.addTarget(self, action: #selector(CourseDetailViewController.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        return textField.intrinsicContentSize.width + 20
    }
    
    func modify(button: UIButton, withText text: String, color: UIColor) {
        button.alpha = 0
        button.titleLabel?.textColor = .white
        button.backgroundColor = color
        button.setTitle(text, for: .normal)
        button.clipsToBounds = true
        informationCard.addSubview(button)
        informationCard.bringSubview(toFront: button)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 找到lesson对应的course
        courseName = lessonList[weekday][lessonNo].course
        for c in courseList {
            if c.course == courseName {
                course = c
            }
        }
        
        for vc in self.childViewControllers {
            if vc is CourseInformationViewController {
                infoVC = vc as! CourseInformationViewController
                break
            }
        }
        fillInformation()
        
        let item = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(CourseDetailViewController.beginEditing(right:)))
        self.navigationItem.rightBarButtonItem = item
        
        courseDetails.delegate = self
        
        bgColor = UIColor(red: 80 / 255, green: 227 / 255, blue: 194 / 255, alpha: 1)
        count = course.lessons.count
        for i in 0..<count {
            let lesson = course.lessons[i]
            
            let textField = UITextField()
            roomTextFields.append(textField)
            var textFieldWidth = modify(textField: textField, withText: lesson.room)
            
            let timeButton = UIButton()
            timeButtons.append(timeButton)
            var alternateString: String
            switch lesson.alternate {
            case 1: alternateString = "单, "
            case 2: alternateString = "双, "
            default: alternateString = ""
            }
            modify(button: timeButton, withText: "\(alternateString)\(weekdayStrings[lesson.weekday])\(lesson.firstClass)-\(lesson.lastClass)节", color: bgColor)
            timeButton.layer.cornerRadius = 6
            let timeWidth = timeButton.intrinsicContentSize.width + 20
            
            deleteButtonState.append(false)
            let deleteButton = UIButton()
            deleteButtons.append(deleteButton)
            modify(button: deleteButton, withText: "✕", color: .lightGray)
            deleteButton.layer.cornerRadius = 12
            deleteButton.addTarget(self, action: #selector(CourseDetailViewController.deleteLesson(button:)), for: .touchUpInside)

            textFieldWidth = min(textFieldWidth, informationCard.bounds.width - timeWidth - 76)
            let posY = CGFloat(48 + i * 36)
            textField.frame = CGRect(x: 12, y: posY, width: textFieldWidth, height: 30)
            timeButton.frame = CGRect(x: textFieldWidth + 24, y: posY, width: timeWidth, height: 30)
            deleteButton.frame = CGRect(x: textFieldWidth + timeWidth + 36, y: posY + 3, width: 24, height: 24)
            
        }
        
        let courseTextFieldWidth = min(modify(textField: courseTextField, withText: course.course),
                                       informationCard.bounds.width - 24)
        courseTextField.frame = CGRect(x: 12, y: 12, width: courseTextFieldWidth, height: 30)
        modify(button: addButton, withText: "＋", color: .lightGray)
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        addButton.layer.cornerRadius = 12
        addButton.frame = CGRect(x: 12, y: CGFloat(48 + count * 36), width: 24, height: 24)
        let teacherTextFieldWidth = min(modify(textField: teacherTextField, withText: course.teacher),
                                        informationCard.bounds.width - 24)
        teacherTextField.frame = CGRect(x: 12, y: CGFloat(78 + count * 36), width: teacherTextFieldWidth, height: 30)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beginEditing(right: UIBarButtonItem) {
        if right.title == "编辑" {
            // 准备编辑
            right.title = "完成"
            self.infoHeightConstraint.constant += CGFloat(40 * count + 12)
            UIView.animate(withDuration: 0.4) { () in
                self.deleteButton.alpha = 1
            }
            UIView.animate(withDuration: 0.2) { () in
                self.infoVC.courseLabel.alpha = 0
                self.infoVC.timeAndLocationLabel.alpha = 0
                self.infoVC.teacherLabel.alpha = 0
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .layoutSubviews, animations: { () in
                self.courseTextField.alpha = 1
                for i in 0..<self.course.lessons.count {
                    self.roomTextFields[i].alpha = 1
                    self.timeButtons[i].alpha = 1
                    self.deleteButtons[i].alpha = 1
                }
                self.addButton.alpha = 1
                self.teacherTextField.alpha = 1
            }, completion: nil)
        } else {
            // 编辑结束
            right.title = "编辑"
            UIView.animate(withDuration: 0.4) { () in
                self.deleteButton.alpha = 0
            }
            UIView.animate(withDuration: 0.2) { () in
                self.courseTextField.alpha = 0
                for i in 0..<self.course.lessons.count {
                    self.roomTextFields[i].alpha = 0
                    self.timeButtons[i].alpha = 0
                    self.deleteButtons[i].alpha = 0
                }
                self.addButton.alpha = 0
                self.teacherTextField.alpha = 0
            }
            self.infoHeightConstraint.constant -= CGFloat(40 * count + 12)
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .layoutSubviews, animations: { () in
                self.infoVC.courseLabel.alpha = 1
                self.infoVC.timeAndLocationLabel.alpha = 1
                self.infoVC.teacherLabel.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: nil)
            let oldCourseName = course.course
            course.course = courseTextField.text!
            for lesson in course.lessons {
                lesson.course = course.course
            }
            for lessons in lessonList {
                for lesson in lessons {
                    if lesson.course == oldCourseName {
                        lesson.course = course.course
                    }
                }
            }
            for i in 0..<count {
                course.lessons[i].room = roomTextFields[i].text!
            }
            course.teacher = teacherTextField.text!
            let filePath = courseDataFilePath()
            NSKeyedArchiver.archiveRootObject(courseList, toFile: filePath)
            fillInformation()
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        if let num = roomTextFields.index(of: textField) {
            let width = min(textField.intrinsicContentSize.width + 20, informationCard.bounds.width - timeButtons[num].bounds.width - 36)
            UIView.animate(withDuration: 0.1) { () -> Void in
                textField.frame.size.width = width
                self.timeButtons[num].frame.origin.x = 24 + width
            }
        } else {
            let width = min(textField.intrinsicContentSize.width + 20, informationCard.bounds.width - 24)
            UIView.animate(withDuration: 0.1) { () -> Void in
                textField.frame.size.width = width
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        notePlaceHolder.isHidden = (textView.text != "")
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.noteHeight.constant = max(textView.contentSize.height, 100)
            self.view.layoutIfNeeded()
        }
    }
    
    func deleteLesson(button: UIButton) {
        let index = deleteButtons.index(of: button)!
        if deleteButtonState[index] {
            if count <= 1 {
                let alertController = UIAlertController(title: "提醒", message: "课程必须保留至少一个安排", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(confirmAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                let lessonToRemove = course.lessons[index]
                course.lessons.remove(at: index)
//                var lessons = lessonList[lessonToRemove.weekday]
//                lessons.remove(at: lessons.index(of: lessonToRemove)!)
                lessonList[lessonToRemove.weekday].remove(at: lessonList[lessonToRemove.weekday].index(of: lessonToRemove)!)
                roomTextFields[index].removeFromSuperview()
                timeButtons[index].removeFromSuperview()
                deleteButtons[index].removeFromSuperview()
                roomTextFields.remove(at: index)
                timeButtons.remove(at: index)
                deleteButtons.remove(at: index)
                count = course.lessons.count
                UIView.animate(withDuration: 0.3) { () in
                    for i in index..<self.count {
                        self.roomTextFields[i].frame.origin.y -= 36
                        self.timeButtons[i].frame.origin.y -= 36
                        self.deleteButtons[i].frame.origin.y -= 36
                    }
                    self.addButton.frame.origin.y -= 36
                    self.teacherTextField.frame.origin.y -= 36
                    self.infoHeightConstraint.constant -= 36
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            deleteButtonState[index] = true
            UIView.animate(withDuration: 0.2) { () in
                button.frame = CGRect(x: button.frame.origin.x, y: button.frame.origin.y - 3, width: 60, height: 30)
                button.layer.cornerRadius = 6
                button.titleLabel?.alpha = 0
            }
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .layoutSubviews, animations: { () in
                button.setTitle("删除", for: .normal)
                button.titleLabel?.alpha = 1
            }, completion: nil)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for i in 0..<count {
            if deleteButtonState[i] {
                deleteButtonState[i] = false
                let button = self.deleteButtons[i]
                UIView.animate(withDuration: 0.2) { () in
                    button.frame = CGRect(x: button.frame.origin.x, y: button.frame.origin.y + 3, width: 24, height: 24)
                    button.layer.cornerRadius = 12
                    button.titleLabel?.alpha = 0
                }
                UIView.animate(withDuration: 0.2, delay: 0.2, options: .layoutSubviews, animations: { () in
                    button.setTitle("✕", for: .normal)
                    button.titleLabel?.alpha = 1
                }, completion: nil)
            }
        }
        courseDetails.resignFirstResponder()
    }
    
    @IBAction func DeleteCourse(_ sender: UIButton) {
        let alertController = UIAlertController(title: "删除课程", message: "删除后将不可恢复", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "删除", style: .destructive) {(alert: UIAlertAction) -> Void in
            // 先移除course对应的所有lesson
            for lesson in self.course.lessons {
                let weekday = lesson.weekday
                let index = lessonList[weekday].index(of: lesson)!
                lessonList[weekday].remove(at: index)
            }
            // 移除course
            let index = courseList.index(of: self.course)
            courseList.remove(at: index!)
            
            let filePath = courseDataFilePath()
            NSKeyedArchiver.archiveRootObject(courseList, toFile: filePath)
            
            self.navigationController?.popViewController(animated: true)?.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

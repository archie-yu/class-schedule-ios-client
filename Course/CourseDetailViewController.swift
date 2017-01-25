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
    
    var course: Course!
    
    var infoVC: CourseInformationViewController!
    
    var roomTextFields: [UITextField] = []
    var timeButtons: [UIButton] = []
    
    @IBOutlet weak var informationCard: UIView!
    @IBOutlet weak var notePlaceHolder: UILabel!
    @IBOutlet weak var courseDetails: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var infoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noteHeight: NSLayoutConstraint!
    
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
                infoVC.courseLabel.text = course.course
                var lessonString = ""
                for lesson in course.lessons {
                    lessonString += "\(lesson.room), \(weekdayStrings[lesson.weekday]) \(lesson.firstClass)-\(lesson.lastClass)节; "
                }
                infoVC.timeAndLocationLabel.text = lessonString.substring(to: lessonString.index(lessonString.endIndex, offsetBy: -2))
                infoVC.teacherTextField.text = course.teacher
                break
            }
        }
        courseDetails.text = course.note
        
        let item = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(CourseDetailViewController.beginEditing(right:)))
        self.navigationItem.rightBarButtonItem = item
        
        deleteButton.isHidden = true
        
        courseDetails.delegate = self
        
        let bgColor = UIColor(red: 80 / 255, green: 227 / 255, blue: 194 / 255, alpha: 1)
        
        count = course.lessons.count
        for i in 0..<count {
            let lesson = course.lessons[i]
            
            let textField = UITextField()
            roomTextFields.append(textField)
            textField.alpha = 0
            textField.tintColor = .white
            textField.textColor = .white
            textField.backgroundColor = bgColor
            textField.textAlignment = .center
            textField.text = lesson.room
            textField.font = UIFont.systemFont(ofSize: 20)
            textField.returnKeyType = .done
            textField.clipsToBounds = true
            textField.layer.cornerRadius = 6
            let locationWidth = textField.intrinsicContentSize.width
            textField.frame = CGRect(x: 12, y: CGFloat(42 + i * 40), width: locationWidth + 20, height: 30)
            informationCard.addSubview(textField)
            informationCard.bringSubview(toFront: textField)
            textField.delegate = self
            textField.addTarget(self, action: #selector(CourseDetailViewController.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
            
            let timeButton = UIButton()
            timeButtons.append(timeButton)
            timeButton.alpha = 0
            timeButton.titleLabel?.textColor = .white
            timeButton.backgroundColor = bgColor
            timeButton.setTitle("\(weekdayStrings[lesson.weekday]) \(lesson.firstClass)-\(lesson.lastClass)节", for: .normal)
            timeButton.clipsToBounds = true
            timeButton.layer.cornerRadius = 6
            let timeWidth = timeButton.intrinsicContentSize.width
            timeButton.frame = CGRect(x: locationWidth + 44, y: CGFloat(42 + i * 40), width: timeWidth + 20, height: 30)
            informationCard.addSubview(timeButton)
            informationCard.bringSubview(toFront: timeButton)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beginEditing(right: UIBarButtonItem) {
        if right.title == "编辑" {
            right.title = "完成"
            
            infoVC.teacherTextField.isUserInteractionEnabled = true
            deleteButton.isHidden = false
            
            self.infoHeightConstraint.constant += CGFloat(40 * count - 28)
            UIView.animate(withDuration: 0.2) { () in
                self.infoVC.timeAndLocationLabel.alpha = 0
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .layoutSubviews, animations: { () in
                for i in 0..<self.course.lessons.count {
                    self.roomTextFields[i].alpha = 1
                    self.timeButtons[i].alpha = 1
                }
                self.view.layoutIfNeeded()
            }, completion: nil)
            
        } else {
            right.title = "编辑"
            infoVC.teacherTextField.isUserInteractionEnabled = false
            deleteButton.isHidden = true
            
            UIView.animate(withDuration: 0.2) { () in
                for i in 0..<self.course.lessons.count {
                    self.roomTextFields[i].alpha = 0
                    self.timeButtons[i].alpha = 0
                }
            }
            self.infoHeightConstraint.constant -= CGFloat(40 * count - 28)
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .layoutSubviews, animations: { () in
                self.infoVC.timeAndLocationLabel.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: nil)
            
//            course.location = locationText.text!
//            infoVC.timeAndLocationLabel.text = "\(course.location), \(weekdays[course.weekday - 1]) \(course.begin)-\(course.end)节"
//            
//            let filePath = courseDataFilePath()
//            NSKeyedArchiver.archiveRootObject(courseList, toFile: filePath)

        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        let num = roomTextFields.index(of: textField)!
        let width = min((textField.text?.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20)]).width)! + 20, informationCard.bounds.width - timeButtons[num].bounds.width - 36)
        UIView.animate(withDuration: 0.1) { () -> Void in
            self.timeButtons[num].frame.origin.x = 24 + width
            textField.frame.size.width = width
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        courseDetails.resignFirstResponder()
    }
    
    @IBAction func DeleteCourse(_ sender: UIButton) {
        
        //删除课程前 弹出警告框
        let alertController = UIAlertController(title: "删除课程", message: "删除后将不可恢复", preferredStyle: .actionSheet)
        
        // 设置2个UIAlertAction
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
        
        // 添加到UIAlertController
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        // 弹出
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

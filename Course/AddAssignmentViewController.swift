//
//  AddAssignmentViewController.swift
//  Course
//
//  Created by Archie Yu on 2016/11/21.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit
import CourseModel

class AddAssignmentViewController : UIViewController, UITextFieldDelegate {
    
    var year = 0
    let max = 16384
    
    var editingItem = ""
    
    var courseOldFrame : CGRect!
    var timeOldFrame : CGRect!
    
    var courseVC : ChooseCourseViewController!
    var timeVC : ChooseTimeViewController!
    
    @IBOutlet weak var shadow: UIButton!
    @IBOutlet weak var courseView: UIView!
    @IBOutlet weak var courseButton: UIButton!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var beginTimeButton: UIButton!
    @IBOutlet weak var endTimeButton: UIButton!
    @IBOutlet weak var contentField: UITextField!
    @IBOutlet weak var contentBackground: UILabel!
    @IBOutlet weak var noteField: UITextField!
    @IBOutlet weak var noteBackground: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        for vc in self.childViewControllers {
            switch vc {
            case is ChooseCourseViewController: courseVC = vc as? ChooseCourseViewController
            case is ChooseTimeViewController: timeVC = vc as? ChooseTimeViewController
            default: break
            }
        }
        
        timeOldFrame = timeView.frame
        courseOldFrame = courseView.frame
        
        shadow.backgroundColor = UIColor.black
        shadow.alpha = 0
        
        contentField.delegate = self
        noteField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddAssignmentViewController.keyboardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddAssignmentViewController.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func beginChooseCourse(_ sender: UIButton) {
        
        editingItem = "course"
        
        self.view.bringSubview(toFront: shadow)
        self.view.bringSubview(toFront: courseView)
        
        let newSize = courseVC!.beginChooseCourse()
        let newFrame = CGRect(origin: CGPoint(x: courseView.frame.minX, y: self.view.frame.height / 2 - newSize.height / 2), size: newSize)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        shadow.alpha = 0.5
        courseView.frame = newFrame
        UIView.commitAnimations()
        
    }
    
    @IBAction func chooseBeginTime(_ sender: UIButton) {
        
        editingItem = "beginTime"
        timeVC?.editingItem = "beginTime"
        
        self.view.bringSubview(toFront: shadow)
        self.view.bringSubview(toFront: timeView)
        
        let newSize = timeVC!.beginChooseTime()
        let newFrame = CGRect(origin: CGPoint(x: courseView.frame.minX, y: self.view.frame.height / 2 - newSize.height / 2), size: newSize)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        shadow.alpha = 0.5
        timeView.frame = newFrame
        UIView.commitAnimations()
        
    }
    
    @IBAction func chooseEndTime(_ sender: UIButton) {
        
        editingItem = "endTime"
        timeVC?.editingItem = "endTime"
        
        self.view.bringSubview(toFront: shadow)
        self.view.bringSubview(toFront: timeView)
        
        let newSize = timeVC!.beginChooseTime()
        let newFrame = CGRect(origin: CGPoint(x: courseView.frame.minX, y: self.view.frame.height / 2 - newSize.height / 2), size: newSize)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        shadow.alpha = 0.5
        timeView.frame = newFrame
        UIView.commitAnimations()
        
    }
    
    @IBAction func editingDidBegin(_ sender: UITextField) {
        
        editingItem = "content"
        
        self.view.bringSubview(toFront: shadow)
        self.view.bringSubview(toFront: contentBackground)
        self.view.bringSubview(toFront: contentField)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        shadow.alpha = 0.5
        UIView.commitAnimations()
        
    }
    
    @IBAction func editNote(_ sender: UITextField) {
        
        editingItem = "note"
        
        self.view.bringSubview(toFront: shadow)
        self.view.bringSubview(toFront: noteBackground)
        self.view.bringSubview(toFront: noteField)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        shadow.alpha = 0.5
        UIView.commitAnimations()
        
    }
    
    @IBAction func endChoose(_ sender: UIControl) {
        
        self.view.bringSubview(toFront: courseButton)
        self.view.bringSubview(toFront: beginTimeButton)
        self.view.bringSubview(toFront: endTimeButton)
        
        switch editingItem {
        case "course":
            courseVC!.endChooseCourse()
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.3)
            shadow.alpha = 0
            courseView.frame = courseOldFrame
            UIView.commitAnimations()
        case "beginTime", "endTime":
            timeVC!.endChooseTime()
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.2)
            shadow.alpha = 0
            timeView.frame = timeOldFrame
            UIView.commitAnimations()
        case "content":
            finishInput(contentField)
        case "note":
            finishInput(noteField)
        default: break
        }
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.origin.y
            var deltaY : CGFloat = 0
            switch(editingItem) {
            case "content":
                let contentHeight = contentField.frame.maxY
                deltaY = keyboardHeight - contentHeight
            case "note":
                let noteHeight = noteField.frame.maxY
                deltaY = keyboardHeight - noteHeight
            default: break
            }
            if deltaY < 0 {
                var frame = self.view.frame
                frame.origin.y = deltaY
                self.view.frame = frame
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // 还原视图位置
        var frame = self.view.frame
        frame.origin.y = 0
        self.view.frame = frame
    }
    
    func finishInput(_ textField: UITextField) {
        
        // 隐藏阴影
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.1)
        shadow.alpha = 0
        UIView.commitAnimations()
        
        textField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        finishInput(textField)
        return true
    }
    
    @IBAction func addAssignmentButtonDown(_ sender: UIBarButtonItem) {
        
        // 检查是否选择了课程
        if courseVC?.courseName == "" {
            let alertController = UIAlertController(title: "提示", message: "未选择课程！", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        // 检查结束时间是否有效
        else if !timeVC.finish {
            let alertController = UIAlertController(title: "提示", message: "未选择结束时间！", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else if timeVC.beginTime.compare(timeVC.endTime) != ComparisonResult.orderedAscending {
            let alertController = UIAlertController(title: "提示", message: "任务结束时间不能晚于开始时间！", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        // 检查是否输入了作业内容
        else if contentField.text == "" {
            let alertController = UIAlertController(title: "提示", message: "未输入作业内容！", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        else {
            let courseName = courseVC.courseName
            let content = contentField.text!
            let beginTime = timeVC.beginTime!
            let endTime = timeVC.endTime!
            assignmentList.append(AssignmentModel(in: courseName, todo: content, from: beginTime, to: endTime))
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
}

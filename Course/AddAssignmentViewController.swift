//
//  AddAssignmentViewController.swift
//  Course
//
//  Created by Archie Yu on 2016/11/21.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit
import CourseModel

class AddAssignmentViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var year = 0
    let max = 16384
    
    var editingItem = ""
    
    var courseOldHeight: CGFloat!
    var timeOldHeight: CGFloat!
    
    var courseVC: ChooseCourseViewController!
    var timeVC: ChooseTimeViewController!
    
    @IBOutlet weak var shadow: UIButton!
    @IBOutlet weak var courseView: UIView!
    @IBOutlet weak var courseButton: UIButton!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var beginTimeButton: UIButton!
    @IBOutlet weak var endTimeButton: UIButton!
    @IBOutlet weak var contentField: UITextField!
    @IBOutlet weak var contentBackground: UILabel!
    @IBOutlet weak var notePlaceHolder: UILabel!
    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var noteBackground: UILabel!
    
    var contentHeight: CGFloat!
    var noteHeight: CGFloat!
    
    @IBOutlet weak var courseViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var courseViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var toButtom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // 在子控制器中找到课程选择界面和时间选择界面对应的控制器
        for vc in self.childViewControllers {
            switch vc {
            case is ChooseCourseViewController: courseVC = vc as! ChooseCourseViewController
            case is ChooseTimeViewController: timeVC = vc as! ChooseTimeViewController
            default: break
            }
        }
        
        contentField.delegate = self
        noteText.delegate = self
        
        // 保存课程选择界面和时间选择界面的初始大小，方便视图变化结束后恢复
        courseOldHeight = courseView.bounds.height
        timeOldHeight = timeView.bounds.height
        contentHeight = contentField.frame.maxY
        noteHeight = noteText.frame.minY + 125
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 注册键盘出现和键盘消失的通知
        let NC = NotificationCenter.default
        NC.addObserver(self,
                       selector: #selector(AddAssignmentViewController.keyboardWillChangeFrame(notification:)),
                       name:NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NC.addObserver(self,
                       selector: #selector(AddAssignmentViewController.keyboardWillHide(notification:)),
                       name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 注销键盘出现和键盘消失的通知
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseCourse(_ sender: UIButton) {
        
        editingItem = "course"
        
        // 将阴影和当前编辑视图前置
        self.view.bringSubview(toFront: shadow)
        self.view.bringSubview(toFront: courseView)
        
        // 计算视图弹出时应该变化的大小
        let newHeight = courseVC!.beginChooseCourse().height
        
        // 渐变
        courseViewHeightConstraint.constant = newHeight
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.shadow.alpha = 0.7
            self.view.layoutIfNeeded()
        })
        
    }
    
    @IBAction func chooseBeginTime(_ sender: UIButton) {
        
        editingItem = "beginTime"
        
        // 开始时间选择器和结束时间选择器共享，利用editingItem进行区分
        timeVC?.editingItem = "beginTime"
        
        // 将阴影和当前编辑视图前置
        self.view.bringSubview(toFront: shadow)
        self.view.bringSubview(toFront: timeView)
        
        // 计算视图弹出时应该变化的大小
        let newSize = timeVC!.beginChooseTime()
        
        // 渐变
        timeViewHeightConstraint.constant = newSize.height
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.shadow.alpha = 0.7
            self.view.layoutIfNeeded()
        })
        
    }
    
    @IBAction func chooseEndTime(_ sender: UIButton) {
        
        editingItem = "endTime"
        
        // 开始时间选择器和结束时间选择器共享，利用editingItem进行区分
        timeVC?.editingItem = "endTime"
        
        // 将阴影和当前编辑视图前置
        self.view.bringSubview(toFront: shadow)
        self.view.bringSubview(toFront: timeView)
        
        // 计算视图弹出时应该变化的大小
        let newSize = timeVC!.beginChooseTime()
        
        // 渐变
        timeViewHeightConstraint.constant = newSize.height
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.shadow.alpha = 0.7
            self.view.layoutIfNeeded()
        })
        
    }
    
    @IBAction func editContent(_ sender: UITextField) {
        
        editingItem = "content"
        
        // 将阴影和当前编辑视图前置
        self.view.bringSubview(toFront: shadow)
        self.view.bringSubview(toFront: contentBackground)
        self.view.bringSubview(toFront: contentField)
        
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.shadow.alpha = 0.7
        })
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        editingItem = "note"
        
        // 将阴影和当前编辑视图前置
        self.view.bringSubview(toFront: shadow)
        self.view.bringSubview(toFront: noteBackground)
        self.view.bringSubview(toFront: noteText)
        self.view.bringSubview(toFront: notePlaceHolder)
        
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.shadow.alpha = 0.7
        })
        
        return true
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        notePlaceHolder.isHidden = (noteText.text != "")
    }
    
    @IBAction func endEdit(_ sender: UIControl) {
        
        // 恢复前置区域
        self.view.bringSubview(toFront: courseButton)
        self.view.bringSubview(toFront: beginTimeButton)
        self.view.bringSubview(toFront: endTimeButton)
        
        // 根据正在编辑的区域恢复视图
        switch editingItem {
        case "course":
            courseVC!.endChooseCourse()
            courseViewHeightConstraint.constant = courseOldHeight
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.shadow.alpha = 0
                self.view.layoutIfNeeded()
            })
        case "beginTime", "endTime":
            timeVC!.endChooseTime()
            timeViewHeightConstraint.constant = timeOldHeight
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.shadow.alpha = 0
                self.view.layoutIfNeeded()
            })
        case "content":
            finishInput(contentField)
        case "note":
            finishInput(noteText)
        default: break
        }
        
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        
        // 获取键盘高度
        let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let keyboardHeight = keyboardFrame.origin.y
        
        // 计算可能需要上移的距离
        var deltaY: CGFloat = 0
        switch(editingItem) {
        case "content":
            deltaY = keyboardHeight - contentHeight - 16
        case "note":
            toButtom.priority = 100
            deltaY = keyboardHeight - noteHeight - 16
        default: break
        }
        // 需要上移时，变化视图位置
        if deltaY < 0 {
            courseViewTopConstraint.constant = deltaY + 16
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.view.layoutIfNeeded()
            })
        }
        
    }

    func keyboardWillHide(notification: NSNotification) {
        
        courseViewTopConstraint.constant = 16
        toButtom.priority = 750
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
             self.shadow.alpha = 0
            self.view.layoutIfNeeded()
        })
        
    }
    
    func finishInput(_ textArea: UIView) {
        textArea.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        finishInput(textField)
        return true
    }
    
    // 用于比较两个任务先后次序
    func endTimeOrder(a: Assignment, b: Assignment) ->Bool {
        return a.endTime.compare(b.endTime) == .orderedAscending
    }
    
    @IBAction func addAssignmentButtonDown(_ sender: UIBarButtonItem) {
        
        var hint: String!
        
        if courseVC?.course == "" {
            hint = "未选择课程！"
        } else if !timeVC.finish {
            hint = "未选择结束时间！"
        } else if timeVC.beginTime.compare(timeVC.endTime) != ComparisonResult.orderedAscending {
            hint = "任务结束时间不能晚于开始时间！"
        } else if contentField.text == "" {
            hint = "未输入作业内容！"
        } else {
            // 将信息保存到assignmentList中
            let course = courseVC.course
            let content = contentField.text!
            let note = noteText.text!
            let beginTime = timeVC.beginTime!
            let endTime = timeVC.endTime!
            assignmentList.append(Assignment(in: course, todo: content, note: note, from: beginTime, to: endTime))
            
            // 插入列表后按结束时间重新排序
            assignmentList.sort(by: endTimeOrder)
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
            return
            
        }
        let alertController = UIAlertController(title: "提示", message: hint, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

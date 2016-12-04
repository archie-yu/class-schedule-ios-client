//
//  AddAssignmentViewController.swift
//  Course
//
//  Created by Archie Yu on 2016/11/21.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit

class AddAssignmentViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var coursePicker: UIPickerView!
    @IBOutlet weak var assignmentText: UITextField!
    @IBOutlet weak var timePicker: UIPickerView!

    var year = 0
    let max = 16384
    var firstEditing = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        coursePicker.delegate = self
        coursePicker.selectRow(max / 2, inComponent: 0, animated: false)
        
        timePicker.delegate = self
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy"
        year = Int(timeFormatter.string(from: date))!
        timeFormatter.dateFormat = "MM"
        let month = Int(timeFormatter.string(from: date))!
        timeFormatter.dateFormat = "dd"
        let day = Int(timeFormatter.string(from: date))!
        timeFormatter.dateFormat = "HH"
        let hour = Int(timeFormatter.string(from: date))!
        timeFormatter.dateFormat = "mm"
        let minute = Int(timeFormatter.string(from: date))!
        timePicker.selectRow(max / 2 - (max / 2 % 4), inComponent: 0, animated: true)
        timePicker.selectRow(max / 2 - (max / 2 % 12) + month - 1, inComponent: 1, animated: true)
        timePicker.selectRow(max / 2 - (max / 2 % 31) + day - 1, inComponent: 2, animated: true)
        timePicker.selectRow(max / 2 - (max / 2 % 24) + hour, inComponent: 3, animated: true)
        timePicker.selectRow(max / 2 - (max / 2 % 60) + minute, inComponent: 4, animated: true)
        
        assignmentText.delegate = self
        
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
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case coursePicker: return 1
        case timePicker: return 5
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return max
//        switch pickerView {
//        case coursePicker: return courseList.count
//        case timePicker:
//            switch component {
//            case 0: return 4
//            case 1: return 12
//            case 2: return 31
//            case 3: return 24
//            case 4: return 60
//            default: return 0
//            }
//        default: return 0
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        let title = UILabel()
        title.textColor = UIColor.white
        switch pickerView {
        case coursePicker:
            title.text = "   " + courseList[(row - max / 2 % courseList.count) % courseList.count].courseName
        case timePicker:
            title.textAlignment = NSTextAlignment.center
            switch component {
            case 0: title.text = String(row % 4 + year)
            case 1: title.text = String(row % 12 + 1)
            case 2: title.text = String(row % 31 + 1)
            case 3: title.text = String(row % 24)
            case 4: title.text = String(row % 60)
            default: title.text = ""
            }
        default: title.text = ""
        }
        return title
    }
    
    func keyboardWillShow(notification: NSNotification) {
//        print("show")
        if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.origin.y
//            let textfieldHeight = assignmentText.frame.maxY
            let timePickerHeight = timePicker.frame.maxY
            let deltaY = keyboardHeight - timePickerHeight
            if deltaY < 0 {
                var frame = self.view.frame
                frame.origin.y = deltaY
                self.view.frame = frame
            }
        }
//        if let userInfo = notification.userInfo, let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue, let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double, let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
//            let frame = value.cgRectValue
//            let intersection = frame.intersection(self.view.frame)
//            
//            let deltaY = intersection.height
//            
////            if keyBoardNeedLayout {
//            UIView.animate(withDuration: duration, delay: 0.0,
//                           options: UIViewAnimationOptions(rawValue: curve),
//                           animations: { _ in
//                            self.view.frame = CGRect(x: 0, y: -deltaY, width: self.view.bounds.width, height: self.view.bounds.height)
////                                                                        self.keyBoardNeedLayout = false
//                            self.view.layoutIfNeeded()
//            }, completion: nil)
////            }
//        
//            
//        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
//        print("hide")
        var frame = self.view.frame
        frame.origin.y = 0
        self.view.frame = frame
//            UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(rawValue: curve), animations: { _ in
//                            self.view.frame = CGRect(x: 0,y: deltaY, width: self.view.bounds.width,height: self.view.bounds.height)
////                            self.keyBoardNeedLayout = true
//                            self.view.layoutIfNeeded()
//            }, completion: nil)
//        }
//        if let userInfo = notification.userInfo, let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double, let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
//            let frame = value.cgRectValue
//            let intersection = frame.intersection(self.view.frame)
//            
//            let deltaY = intersection.height
//            
//            UIView.animate(withDuration: duration, delay: 0.0,
//                                       options: UIViewAnimationOptions(rawValue: curve),
//                                       animations: { _ in
//                                        self.view.frame = CGRect(x: 0,y: deltaY, width: self.view.bounds.width,height: self.view.bounds.height)
////                                        self.keyBoardNeedLayout = true
//                                        self.view.layoutIfNeeded()
//            }, completion: nil)
//            
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func editingDidBegin(_ sender: UITextField) {
        if firstEditing {
            sender.text = ""
            sender.textColor = UIColor.white
            sender.alpha = 1
            firstEditing = false
        }
    }
    
    @IBAction func addAssignmentButtonDown(_ sender: UIBarButtonItem) {
        if firstEditing == false && assignmentText.text != "" {
            let courseName = courseList[coursePicker.selectedRow(inComponent: 0) % courseList.count].courseName
            let content = assignmentText.text!
            let month = 1 + timePicker.selectedRow(inComponent: 1) % 12
            var monthString : String
            if month >= 10 {
                monthString = String(month)
            }
            else {
                monthString = "0" + String(month)
            }
            let day = 1 + timePicker.selectedRow(inComponent: 2) % 31
            var dayString : String
            if day >= 10 {
                dayString = String(day)
            }
            else {
                dayString = "0" + String(day)
            }
            let hour = timePicker.selectedRow(inComponent: 3) % 24
            var hourString : String
            if hour >= 10 {
                hourString = String(hour)
            }
            else {
                hourString = "0" + String(hour)
            }
            let minute = timePicker.selectedRow(inComponent: 4) % 60
            var minuteString : String
            if minute >= 10 {
                minuteString = String(minute)
            }
            else {
                minuteString = "0" + String(minute)
            }
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyyyMMddHHmm"
            let time = timeFormatter.date(from: String(year + timePicker.selectedRow(inComponent: 0) % 4)
                + monthString + dayString + hourString + minuteString)
            assignmentList.append(AssignmentModel(courseName, content, time!))
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        else {
//            let malert = UIAlertView(title: "提示", message: "未输入作业内容！", delegate: self, cancelButtonTitle: "确定")
//            alert.alertViewStyle = UIAlertViewStyle.default
            let alertController = UIAlertController(title: "提示", message: "未输入作业内容！", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}

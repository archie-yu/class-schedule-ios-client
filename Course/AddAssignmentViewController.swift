//
//  AddAssignmentViewController.swift
//  Course
//
//  Created by Archie Yu on 2016/11/21.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit

class AddAssignmentViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var year = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        coursePicker.delegate = self
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
        timePicker.selectRow(0, inComponent: 0, animated: true)
        timePicker.selectRow(month - 1, inComponent: 1, animated: true)
        timePicker.selectRow(day - 1, inComponent: 2, animated: true)
        timePicker.selectRow(hour, inComponent: 3, animated: true)
        timePicker.selectRow(minute, inComponent: 4, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var coursePicker: UIPickerView!
    @IBOutlet weak var assignmentText: UITextField!
    @IBOutlet weak var timePicker: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case coursePicker: return 1
        case timePicker: return 5
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case coursePicker: return courseList.count
        case timePicker:
            switch component {
            case 0: return 4
            case 1: return 12
            case 2: return 31
            case 3: return 24
            case 4: return 60
            default: return 0
            }
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        let title = UILabel()
        title.textColor = UIColor.white
        title.textAlignment = NSTextAlignment.center
        switch pickerView {
        case coursePicker: title.text = courseList[row].courseName
        case timePicker:
            switch component {
            case 0: title.text = String(row + year)
            case 1, 2: title.text = String(row + 1)
            case 3, 4: title.text = String(row)
            default: title.text = ""
            }
        default: title.text = ""
        }
        return title
    }
    
}

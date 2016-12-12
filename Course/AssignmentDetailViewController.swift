//
//  AssignmentDetailViewController.swift
//  Course
//
//  Created by Archie Yu on 2016/12/4.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit

class AssignmentDetailViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let max = 16384
    var year = 0
    var courseName = ""
    var assignmentNo = -1
    var timePicker : UIPickerView?
    
    @IBOutlet weak var assignmentContent: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
//        courseNameLabel.text = courseName
        self.title = assignmentList[assignmentNo].courseName
        assignmentContent.text = assignmentList[assignmentNo].content
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        timePicker = UIPickerView()
        
        timePicker?.delegate = self
        timePicker?.dataSource = self
        
        let curDate = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy"
        year = Int(timeFormatter.string(from: curDate))!
        timeFormatter.dateFormat = "MM"
        let month = Int(timeFormatter.string(from: curDate))!
        timeFormatter.dateFormat = "dd"
        let day = Int(timeFormatter.string(from: curDate))!
        timeFormatter.dateFormat = "HH"
        let hour = Int(timeFormatter.string(from: curDate))!
        timeFormatter.dateFormat = "mm"
        let minute = Int(timeFormatter.string(from: curDate))!
        timePicker?.selectRow(max / 2 - (max / 2 % 4), inComponent: 0, animated: true)
        timePicker?.selectRow(max / 2 - (max / 2 % 12) + month - 1, inComponent: 1, animated: true)
        timePicker?.selectRow(max / 2 - (max / 2 % 31) + day - 1, inComponent: 2, animated: true)
        timePicker?.selectRow(max / 2 - (max / 2 % 24) + hour, inComponent: 3, animated: true)
        timePicker?.selectRow(max / 2 - (max / 2 % 60) + minute, inComponent: 4, animated: true)
        
    }
    
    @IBAction func checkRemainingTime(_ sender: Any) {
        
        let editTimeController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let beginHandler = {(action:UIAlertAction!) -> Void in
            let editBeginTimeController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
            
            let margin : CGFloat = 0.0
            let rect = CGRect(x: 0, y: margin, width: editTimeController.view.bounds.size.width, height: 230)
            self.timePicker?.frame = rect
//            self.timePicker?.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
            
            editBeginTimeController.view.addSubview(self.timePicker!)
            
            let confirm = UIAlertAction(title: "确定", style: .default, handler: nil)
            editBeginTimeController.addAction(confirm)
            
            self.present(editBeginTimeController, animated: true, completion: nil)
        }
        let begin = UIAlertAction(title: "开始时间", style: .default, handler: beginHandler)
        
        let end = UIAlertAction(title: "结束时间", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        editTimeController.addAction(begin)
        editTimeController.addAction(end)
        editTimeController.addAction(cancel)
        
        self.present(editTimeController, animated: true, completion: nil)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return max
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        let title = UILabel()
        title.textColor = UIColor.black
        title.textAlignment = NSTextAlignment.center
        switch component {
        case 0: title.text = String(row % 4 + year)
        case 1: title.text = String(row % 12 + 1)
        case 2: title.text = String(row % 31 + 1)
        case 3: title.text = String(row % 24)
        case 4: title.text = String(row % 60)
        default: title.text = ""
        }
        return title
    }
    
}

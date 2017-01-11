//
//  AssignmentDetailViewController.swift
//  Course
//
//  Created by Archie Yu on 2016/12/4.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit

class AssignmentDetailViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var assignmentNo = -1
    var courseName = ""
    
    let max = 16384
    var year = 0
    
    var timePicker : UIPickerView?
    
    @IBOutlet weak var assignmentContent: UILabel!
    @IBOutlet weak var battery: UILabel!
    @IBOutlet weak var remainingTime: UILabel!
    
    var batteryWidth : CGFloat = 250
    var batteryX : CGFloat = 62
    var batteryY : CGFloat = 263
    
    var timer: Timer!
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = assignmentList[assignmentNo].courseName
        assignmentContent.text = assignmentList[assignmentNo].content
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        timePicker = UIPickerView()
        
        timePicker?.delegate = self
        timePicker?.dataSource = self
        
        fresh()
        
        // 启用计时器，控制每秒执行一次tickDown方法
        timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector:#selector(AssignmentDetailViewController.fresh), userInfo:nil, repeats:true)
        
        // 得到当前年份
        let curTime = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy"
        year = Int(timeFormatter.string(from: curTime))!
        
    }
    
    func fresh() {
        
        let current = Date()
        let fromNow = assignmentList[assignmentNo].endTime.timeIntervalSince(current)
        
        // 处理过期任务
        if fromNow < 0 {
            // 电量显示条长度为0
            let frame = CGRect(x: batteryX, y: batteryY, width: 0, height: battery.bounds.height)
            battery.frame = frame
            // 无剩余时间
            remainingTime.text = "任务过期"
        } else {
            let fromBegin = assignmentList[assignmentNo].endTime.timeIntervalSince(assignmentList[assignmentNo].beginTime)
            // 计算电量显示条长度和剩余时间
            var ratio : CGFloat = 1
            if fromNow > fromBegin {
                remainingTime.text = "任务还未开始"
            } else {
                ratio = CGFloat(fromNow / fromBegin)
                var sec = Int(fromNow)
                var min = sec / 60
                sec %= 60
                var hour = min / 60
                min %= 60
                let day = hour / 24
                hour %= 24
                if day > 0 {
                    remainingTime.text = String(format: "%d:%02d:%02d:%02d", arguments: [day, hour, min, sec])
                } else if hour > 0 {
                    remainingTime.text = String(format: "%02d:%02d:%02d", arguments: [hour, min, sec])
                } else {
                    remainingTime.text = String(format: "%02d:%02d", arguments: [min, sec])
                }
            }
            let frame = CGRect(x: batteryX, y: batteryY, width: batteryWidth * ratio, height: battery.bounds.height)
            battery.frame = frame
        }
        
    }
    
    @IBAction func checkRemainingTime(_ sender: Any) {
        
        let editTimeController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let beginHandler = {(action:UIAlertAction!) -> Void in
            let editBeginTimeController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
            
            let margin : CGFloat = 0.0
            let rect = CGRect(x: 0, y: margin, width: editTimeController.view.bounds.size.width, height: 230)
            self.timePicker?.frame = rect
//            self.timePicker?.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
            
            // 设置为开始时间
            
            let beginTime = assignmentList[self.assignmentNo].beginTime
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyyy"
            let year = Int(timeFormatter.string(from: beginTime))!
            timeFormatter.dateFormat = "MM"
            let month = Int(timeFormatter.string(from: beginTime))!
            timeFormatter.dateFormat = "dd"
            let day = Int(timeFormatter.string(from: beginTime))!
            timeFormatter.dateFormat = "HH"
            let hour = Int(timeFormatter.string(from: beginTime))!
            timeFormatter.dateFormat = "mm"
            let minute = Int(timeFormatter.string(from: beginTime))!
            
            let max = self.max
            
            self.timePicker?.selectRow(max / 2 - (max / 2 % 4) + year - self.year, inComponent: 0, animated: true)
            self.timePicker?.selectRow(max / 2 - (max / 2 % 12) + month - 1, inComponent: 1, animated: true)
            self.timePicker?.selectRow(max / 2 - (max / 2 % 31) + day - 1, inComponent: 2, animated: true)
            self.timePicker?.selectRow(max / 2 - (max / 2 % 24) + hour, inComponent: 3, animated: true)
            self.timePicker?.selectRow(max / 2 - (max / 2 % 60) + minute, inComponent: 4, animated: true)
            
            
            // 添加到AlertController中
            editBeginTimeController.view.addSubview(self.timePicker!)
            
            let confirm = UIAlertAction(title: "确定", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "取消", style: .default, handler: nil)
            
            editBeginTimeController.addAction(confirm)
            editBeginTimeController.addAction(cancel)
            
            self.present(editBeginTimeController, animated: true, completion: nil)
        }
        let begin = UIAlertAction(title: "开始时间", style: .default, handler: beginHandler)
        
        let endHandler = {(action:UIAlertAction!) -> Void in
            let editEndTimeController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
            
            let margin : CGFloat = 0.0
            let rect = CGRect(x: 0, y: margin, width: editTimeController.view.bounds.size.width, height: 230)
            self.timePicker?.frame = rect
//            self.timePicker?.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
            
            // 设置为结束时间
            
            let endTime = assignmentList[self.assignmentNo].endTime
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyyy"
            let year = Int(timeFormatter.string(from: endTime))!
            timeFormatter.dateFormat = "MM"
            let month = Int(timeFormatter.string(from: endTime))!
            timeFormatter.dateFormat = "dd"
            let day = Int(timeFormatter.string(from: endTime))!
            timeFormatter.dateFormat = "HH"
            let hour = Int(timeFormatter.string(from: endTime))!
            timeFormatter.dateFormat = "mm"
            let minute = Int(timeFormatter.string(from: endTime))!
            
            let max = self.max
            
            self.timePicker?.selectRow(max / 2 - (max / 2 % 4) + year - self.year, inComponent: 0, animated: true)
            self.timePicker?.selectRow(max / 2 - (max / 2 % 12) + month - 1, inComponent: 1, animated: true)
            self.timePicker?.selectRow(max / 2 - (max / 2 % 31) + day - 1, inComponent: 2, animated: true)
            self.timePicker?.selectRow(max / 2 - (max / 2 % 24) + hour, inComponent: 3, animated: true)
            self.timePicker?.selectRow(max / 2 - (max / 2 % 60) + minute, inComponent: 4, animated: true)
            
            
            // 添加到AlertController中
            editEndTimeController.view.addSubview(self.timePicker!)
            
            let confirm = UIAlertAction(title: "确定", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "取消", style: .default, handler: nil)
            
            editEndTimeController.addAction(confirm)
            editEndTimeController.addAction(cancel)
            
            self.present(editEndTimeController, animated: true, completion: nil)
        }
        let end = UIAlertAction(title: "结束时间", style: .default, handler: endHandler)
        
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

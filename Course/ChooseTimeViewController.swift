//
//  ChooseTimeViewController.swift
//  Course
//
//  Created by Archie Yu on 2016/12/8.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit

class ChooseTimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let max = 16384
    
    var year = 0
    
    let timePicker = UIPickerView()
    
    var editingItem = ""
    var beginTime : Date!
    var endTime : Date!
    
    var finish = false
    
    @IBOutlet weak var beginTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePicker.delegate = self
        timePicker.dataSource = self
        
        // 初始化开始与结束时间
        beginTime = Date()
        endTime = Date()
        
        // 默认选择当前时间为开始时间
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute], from: beginTime)
        beginTimeLabel.text = "开始：" + String(
            format: "%d.%02d.%02d %02d:%02d", dateComponents.year!,
            dateComponents.month!, dateComponents.day!,
            dateComponents.hour!, dateComponents.minute!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beginChooseTime() -> CGSize {
        
        // 隐藏开始时间和结束时间
        beginTimeLabel.isHidden = true
        endTimeLabel.isHidden = true
        
        // 获取初始时间
        var timeComponents : DateComponents!
        switch(editingItem) {
        case "beginTime":
            let calendar = Calendar.current
            timeComponents = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute], from: beginTime)
        case "endTime":
            let calendar = Calendar.current
            timeComponents = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute], from: endTime)
        default: break
        }
        
        // 计算初始行数
        let middle = max / 2
        year = timeComponents.year!
        let yearRow = middle - (middle % 9) + 4
        let monthRow = middle - (middle % 12) + timeComponents.month! - 1
        let dayRow = middle - (middle % 31) + timeComponents.day! - 1
        let hourRow = middle - (middle % 24) + timeComponents.hour!
        let minuteRow = middle - (middle % 60) + timeComponents.minute!
        
        // 选择初始行数
        timePicker.selectRow(yearRow, inComponent: 0, animated: true)
        timePicker.selectRow(monthRow, inComponent: 1, animated: true)
        timePicker.selectRow(dayRow, inComponent: 2, animated: true)
        timePicker.selectRow(hourRow, inComponent: 3, animated: true)
        timePicker.selectRow(minuteRow, inComponent: 4, animated: true)
        
        // 显示时间选择器
        self.view.addSubview(timePicker)
        
        // 计算选择器需要的区域大小
        let size = CGSize(width: self.view.frame.width, height: timePicker.frame.height)
        
        // 设置选择器的区域
        timePicker.frame.size = size
        
        // 返回显示选择器需要的区域大小
        return CGSize(width: self.view.frame.width, height: timePicker.frame.height)
        
    }
    
    func endChooseTime() {
        
        // 根据时间选择器的行数，计算所选时间对应的字符串
        let yearStr = "\(year + timePicker.selectedRow(inComponent: 0) % 9 - 4)"
        
        let month = 1 + timePicker.selectedRow(inComponent: 1) % 12
        let monthStr = String(format: "%02d", month)
        
        let day = 1 + timePicker.selectedRow(inComponent: 2) % 31
        let dayStr = String(format: "%02d", day)
        
        let hour = timePicker.selectedRow(inComponent: 3) % 24
        let hourStr = String(format: "%02d", hour)
        
        let minute = timePicker.selectedRow(inComponent: 4) % 60
        let minuteStr = String(format: "%02d", minute)
        
        let timeStr = "\(yearStr).\(monthStr).\(dayStr) \(hourStr):\(minuteStr)"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        
        // 计算开始时间和结束时间
        switch(editingItem) {
        case "beginTime":
            beginTime = timeFormatter.date(from: timeStr)
            beginTimeLabel.text = "开始：" + timeStr
        case "endTime":
            endTime = timeFormatter.date(from: timeStr)
            endTimeLabel.text = "结束：" + timeStr
            finish = true
        default: break
        }
        
        // 重新显示开始时间和结束时间
        beginTimeLabel.isHidden = false
        endTimeLabel.isHidden = false
        
        // 隐藏时间选择器
        timePicker.removeFromSuperview()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return max
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        // 为某行某列设置对应的时间
        let title = UILabel()
        title.textColor = UIColor.black
        title.textAlignment = NSTextAlignment.center
        switch component {
        case 0: title.text = String(row % 9 + year - 4)
        case 1: title.text = String(row % 12 + 1)
        case 2: title.text = String(row % 31 + 1)
        case 3: title.text = String(row % 24)
        case 4: title.text = String(row % 60)
        default: title.text = ""
        }
        return title
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

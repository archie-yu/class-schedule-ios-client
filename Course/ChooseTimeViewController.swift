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
    var time : Date?
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.layer.cornerRadius = 4
        self.view.clipsToBounds = true
        
        timePicker.delegate = self
        timePicker.dataSource = self
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
        timePicker.selectRow(max / 2 - (max / 2 % 4), inComponent: 0, animated: true)
        timePicker.selectRow(max / 2 - (max / 2 % 12) + month - 1, inComponent: 1, animated: true)
        timePicker.selectRow(max / 2 - (max / 2 % 31) + day - 1, inComponent: 2, animated: true)
        timePicker.selectRow(max / 2 - (max / 2 % 24) + hour, inComponent: 3, animated: true)
        timePicker.selectRow(max / 2 - (max / 2 % 60) + minute, inComponent: 4, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beginChooseTime() -> CGSize {
        infoLabel.isHidden = true
        self.view.addSubview(timePicker)
        timePicker.frame.size = CGSize(width: self.view.frame.width, height: timePicker.frame.height)
        return CGSize(width: self.view.frame.width, height: timePicker.frame.height)
    }
    
    func endChooseTime() {
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
        let timeString = String(year + timePicker.selectedRow(inComponent: 0) % 4) + " " + monthString + " " + dayString + " " + hourString + " " + minuteString
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy MM dd HH mm"
        time = timeFormatter.date(from: timeString)
        infoLabel.text = timeString
        infoLabel.isHidden = false
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

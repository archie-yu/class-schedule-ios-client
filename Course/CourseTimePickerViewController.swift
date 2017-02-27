//
//  CourseTimePickerViewController.swift
//  Course
//
//  Created by Archie Yu on 2017/2/1.
//  Copyright © 2017年 Archie Yu. All rights reserved.
//

import UIKit

class CourseTimePickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let courseTimePickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.clipsToBounds = true
        view.addSubview(courseTimePickerView)
        
        courseTimePickerView.delegate = self
        courseTimePickerView.dataSource = self
        
        courseTimePickerView.selectRow(0, inComponent: 0, animated: true)
        courseTimePickerView.selectRow(weekNum - 1, inComponent: 1, animated:true)
        courseTimePickerView.selectRow(0, inComponent: 2, animated: true)
        courseTimePickerView.selectRow(0, inComponent: 3, animated: true)
        courseTimePickerView.selectRow(0, inComponent: 4, animated: true)
        courseTimePickerView.selectRow(1, inComponent: 5, animated: true)
    }
    
    func expand(withFrame frame: CGRect) {
        view.frame = frame
        courseTimePickerView.frame = CGRect(x: 1, y: 0, width: frame.width - 2, height: frame.height)
    }
    
    func compact(withFrame frame: CGRect) {
        view.frame = frame
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0, 1: return weekNum
        case 2: return 3
        case 3: return weekdayNum
        case 4, 5: return courseNum
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        for subView in pickerView.subviews {
            if subView.frame.size.height < 1 {
                subView.backgroundColor = UIColor(white: 1, alpha: 0.3)
            }
        }
        let title = UILabel()
        title.textColor = UIColor.white
        title.textAlignment = NSTextAlignment.center
        title.font = UIFont.boldSystemFont(ofSize: 19)
        switch component {
        case 0, 1: title.text = String(row + 1)
        case 2:
            switch row {
            case 0: title.text = "全"
            case 1: title.text = "单"
            case 2: title.text = "双"
            default: break
            }
        case 3: title.text = weekdayStrings[row]
        case 4, 5: title.text = String(row + 1)
        default: break
        }
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }

}

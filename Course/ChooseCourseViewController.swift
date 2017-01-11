//
//  ChooseCourseViewController.swift
//  Course
//
//  Created by Archie Yu on 2016/12/8.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit

class ChooseCourseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let max = 16384
    
    var course = ""
    
    let coursePicker = UIPickerView()

    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // 设置圆角
        self.view.layer.cornerRadius = 4
        self.view.clipsToBounds = true
        
        coursePicker.delegate = self
        coursePicker.dataSource = self
        
        // 设置课程选择器初始行数
        coursePicker.selectRow(max / 2 - max / 2 % courseList.count, inComponent: 0, animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beginChooseCourse() -> CGSize {
        
        // 隐藏课程名
        infoLabel.isHidden = true
        
        // 显示课程选择器
        self.view.addSubview(coursePicker)
        
        // 计算选择器需要的区域大小
        let size = CGSize(width: self.view.frame.width, height: coursePicker.frame.height)
        
        // 设置选择器的区域
        coursePicker.frame.size = size
        
        // 返回显示选择器需要的区域大小
        return size
        
    }
    
    func endChooseCourse() {
        
        // 获取选择的课程名
        course = courseList[coursePicker.selectedRow(inComponent: 0) % courseList.count].course
        infoLabel.text = course
        
        // 显示课程名
        infoLabel.isHidden = false
        
        // 隐藏课程选择器
        coursePicker.removeFromSuperview()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return max
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int,
    reusing view: UIView?) -> UIView {
        // 为某一行设置对应的课程名
        let title = UILabel()
        title.textColor = UIColor.black
        title.text = courseList[row % courseList.count].course
        title.textAlignment = NSTextAlignment.center
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

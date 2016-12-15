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
    let coursePicker = UIPickerView()
    var courseName = ""

    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.layer.cornerRadius = 4
        self.view.clipsToBounds = true
        
        coursePicker.delegate = self
        coursePicker.dataSource = self
        coursePicker.selectRow(max / 2, inComponent: 0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beginChooseCourse() -> CGSize {
        infoLabel.isHidden = true
        self.view.addSubview(coursePicker)
        coursePicker.frame.size = CGSize(width: self.view.frame.width, height: coursePicker.frame.height)
        
        return CGSize(width: self.view.frame.width, height: coursePicker.frame.height)
    }
    
    func endChooseCourse() {
        courseName = courseList[coursePicker.selectedRow(inComponent: 0) % courseList.count].courseName
        infoLabel.text = courseName
        infoLabel.isHidden = false
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
        let title = UILabel()
        title.textColor = UIColor.black
        title.text = courseList[(row - max / 2 % courseList.count) % courseList.count].courseName
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

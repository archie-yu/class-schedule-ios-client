//
//  CourseMainViewController.swift
//  Course
//
//  Created by Cedric on 2016/12/8.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit
import CourseModel

class CourseMainViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var coursePageVC: UIPageViewController!
    var dayControllers: [DisplayCoursesViewController] = []
    
    var nextWeekday = 0
    var selectingWeek = false
    
    var editView: UIView!
    var labelView: UILabel!
    var pickerView: UIPickerView!
    let offset: CGFloat = -18
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var weekdayPageControl: UIPageControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        load(from: courseDataFilePath())
        
        for vc in self.childViewControllers {
            if vc is UIPageViewController {
                coursePageVC = vc as! UIPageViewController
            }
        }
        coursePageVC.delegate = self
        coursePageVC.dataSource = self
        
        weekdayPageControl.numberOfPages = weekdayNum
        for i in 0..<7 {
            dayControllers.append(
                storyboard?.instantiateViewController(withIdentifier: "DayCourse") as!
                DisplayCoursesViewController)
            dayControllers[i].weekday = i
        }
        
        titleButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        
        let width = UIScreen.main.bounds.width
        var frame = CGRect(x: 0, y: -224, width: width, height: 224)
        editView = UIView(frame: frame)
        editView.backgroundColor = UIColor(white: 0.05, alpha: 1)
        self.view.addSubview(editView)
        
        frame = CGRect(x: offset, y: -100, width: width, height: 40)
        labelView = UILabel(frame: frame)
        labelView.text = "当前为第\t\t\t星期"
        labelView.textColor = .white
        labelView.textAlignment = .center
        self.view.addSubview(labelView)
        
        frame = CGRect(x: 0, y: -162, width: width, height: 162)
        pickerView = UIPickerView(frame: frame)
        pickerView.dataSource = self
        pickerView.delegate = self
        self.view.addSubview(pickerView)
        
        pickerView.selectRow(currentWeek - 1, inComponent: 0, animated: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if needReload {
            weekdayPageControl.numberOfPages = weekdayNum
            var weekday = (Calendar.current.dateComponents([.weekday], from: Date()).weekday! + 5) % 7
            if weekday >= weekdayNum { weekday = 0 }
            weekdayPageControl.currentPage = weekday
            coursePageVC.setViewControllers(
                [dayControllers[weekday]], direction: .forward, animated: false, completion: nil)
            needReload = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let nextWeekday = (weekdayPageControl.currentPage + 1) % weekdayNum
        return dayControllers[nextWeekday]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let nextWeekday = (weekdayPageControl.currentPage + weekdayNum - 1) % weekdayNum
        return dayControllers[nextWeekday]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        if let displayController = pendingViewControllers[0] as? DisplayCoursesViewController {
            nextWeekday = displayController.weekday
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            weekdayPageControl.currentPage = nextWeekday
        }
        
    }
    
    @IBAction func changeWeek(_ sender: UIButton) {
        
        let width = UIScreen.main.bounds.width
        
        if selectingWeek {
            titleButton.setTitle("课程", for: .normal)
            titleButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
            let frame = CGRect(x: 0, y: -224, width: width, height: 224)
            let labelFrame = CGRect(x: offset, y: -100, width: width, height: 40)
            let pickerFrame = CGRect(x: 0, y: -162, width: width, height: 162)
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.editView.frame = frame
                self.labelView.frame = labelFrame
                self.pickerView.frame = pickerFrame
            })
            currentWeek = pickerView.selectedRow(inComponent: 0) + 1
        } else {
            titleButton.setTitle("确认", for: .normal)
            titleButton.titleLabel?.font = .boldSystemFont(ofSize: 21)
            let frame = CGRect(x: 0, y: 0, width: width, height: 224)
            let labelFrame = CGRect(x: offset, y: 124, width: width, height: 40)
            let pickerFrame = CGRect(x: 0, y: 64, width: width, height: 162)
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.editView.frame = frame
                self.labelView.frame = labelFrame
                self.pickerView.frame = pickerFrame
            })
        }
        selectingWeek = !selectingWeek
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weekNum
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = "\(row + 1)"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        label.textAlignment = .center
        return label
    }
    
}

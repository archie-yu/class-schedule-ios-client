//
//  CourseMainViewController.swift
//  Course
//
//  Created by Cedric on 2016/12/8.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit
import CourseModel

class CourseMainViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var coursePageVC: UIPageViewController!
    var dayControllers: [DisplayCoursesViewController] = []
    
    var nextWeekday = 0
    
    @IBOutlet weak var weekdayPageControl: UIPageControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for _ in 0..<weekdayNum {
            everydayCourseList.append([])
        }
        
        let filePath = courseDataFilePath()
        if (FileManager.default.fileExists(atPath: filePath)) {
            courseList = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! [CourseModel]
        }
        for course in courseList {
            everydayCourseList[course.weekday - 1].append(course)
        }
        
        for vc in self.childViewControllers {
            if vc is UIPageViewController {
                coursePageVC = vc as! UIPageViewController
            }
        }
        
        coursePageVC.delegate = self
        coursePageVC.dataSource = self
        
        weekdayPageControl.numberOfPages = weekdayNum
        for i in 0..<weekdayNum {
            dayControllers.append(
                storyboard?.instantiateViewController(withIdentifier: "DayCourse") as!
                DisplayCoursesViewController)
            dayControllers[i].weekday = i
        }
        
        weekdayPageControl.currentPage = 0
        coursePageVC.setViewControllers(
            [dayControllers[0]], direction: .forward, animated: false, completion: nil)
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

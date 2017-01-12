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
    
    @IBOutlet weak var weekdayPageControl: UIPageControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        weekdayPageControl.numberOfPages = 5
        for i in 0...4 {
            dayControllers.append(
                storyboard?.instantiateViewController(withIdentifier: "DayCourse") as!
                DisplayCoursesViewController)
            dayControllers[i].weekday = i
        }
        
        weekdayPageControl.currentPage = 0
        coursePageVC.setViewControllers(
            [dayControllers[0]], direction: .forward, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let dayController = viewController as! DisplayCoursesViewController
        let nextWeekday = (dayController.weekday + 1) % 5
//        let nextWeekday = (weekdayPageControl.currentPage + 1) % 5
        weekdayPageControl.currentPage = nextWeekday
        return dayControllers[nextWeekday]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let dayController = viewController as! DisplayCoursesViewController
        let lastWeekday = (dayController.weekday + 4) % 5
//        let lastWeekday = (weekdayPageControl.currentPage + 4) % 5
        weekdayPageControl.currentPage = lastWeekday
        return dayControllers[lastWeekday]
        
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

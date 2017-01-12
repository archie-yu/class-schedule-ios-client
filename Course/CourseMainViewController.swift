//
//  CourseMainViewController.swift
//  Course
//
//  Created by Cedric on 2016/12/8.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit
import CourseModel

class CourseMainViewController: UIViewController, UIPageViewControllerDataSource {
    
    var PageViewController:CoursePageViewController!
    
    @IBOutlet weak var weekdayPageControl: UIPageControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let filePath = courseDataFilePath()
        if (FileManager.default.fileExists(atPath: filePath)) {
            courseList = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! [CourseModel]
        }
        for course in courseList {
            everydayCourseList[course.weekday - 2].append(course)
        }
        
        PageViewController = self.childViewControllers.first as!
        CoursePageViewController
        
        PageViewController.dataSource = self
        
        PageViewController.setViewControllers([PageViewController.mondayController!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        weekdayPageControl.numberOfPages = 5
        weekdayPageControl.currentPage = 0
        
        //weekdayPageControl.addTarget(self, action: #selector(pageChanged(_:)),
                              //forControlEvents;: UIControlEvents.ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let daycontroller = viewController as? DisplayCoursesViewController{
           // print("here")
           //print(weekdayPageControl.currentPage)
            let weekday = daycontroller.getWeekday()
           //print("weekay is" + String(weekday))
            //currentPage从0开始计数，而weekday从1开始计数
            //所以存在错开现象
            //weekdayPageControl.currentPage = (weekdayPageControl.currentPage + 1) % 5
            
            switch weekday {
            case 1:
                weekdayPageControl.currentPage = 1
                return PageViewController.tuesdayController
            case 2:
                weekdayPageControl.currentPage = 2
                return PageViewController.wednesdayController
            case 3:
                weekdayPageControl.currentPage = 3
                return PageViewController.thursdayController
            case 4:
                weekdayPageControl.currentPage = 4
                return PageViewController.fridayController
            case 5:
                weekdayPageControl.currentPage = 0
                return PageViewController.mondayController
            default: break
            }
            
        }
        
        return nil
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let daycontroller = viewController as? DisplayCoursesViewController{
            
            let weekday = daycontroller.getWeekday()
            
            /*
            var numPage = weekdayPageControl.currentPage - 1
            if numPage < 0{
                numPage += 5
            }
            weekdayPageControl.currentPage = numPage
            */
            //currentPage从0开始计数，而weekday从1开始计数
            //所以存在错开现象
            switch weekday {
            case 1:
                weekdayPageControl.currentPage = 4
                return PageViewController.fridayController
            case 2:
                weekdayPageControl.currentPage = 0
                return PageViewController.mondayController
            case 3:
                weekdayPageControl.currentPage = 1
                return PageViewController.tuesdayController
            case 4:
                weekdayPageControl.currentPage = 2
                return PageViewController.wednesdayController
            case 5:
                weekdayPageControl.currentPage = 3
                return PageViewController.thursdayController
            default: break
                
            }
            
        }
        
        return nil
        
    }

}

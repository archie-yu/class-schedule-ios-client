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
            
            let weekday = daycontroller.getWeekday()
            
            switch weekday {
            case 1:
                return PageViewController.tuesdayController
            case 2:
                return PageViewController.wednesdayController
            case 3:
                return PageViewController.thursdayController
            case 4:
                return PageViewController.fridayController
            case 5:
                return PageViewController.mondayController
            default: break
            }
            
        }
        
        return nil
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let daycontroller = viewController as? DisplayCoursesViewController{
            
            let weekday = daycontroller.getWeekday()
            
            switch weekday {
            case 1:
                return PageViewController.fridayController
            case 2:
                return PageViewController.mondayController
            case 3:
                return PageViewController.tuesdayController
            case 4:
                return PageViewController.wednesdayController
            case 5:
                return PageViewController.thursdayController
            default: break
                
            }
            
        }
        
        return nil
        
    }
    
}

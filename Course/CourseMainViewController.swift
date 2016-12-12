//
//  CourseMainViewController.swift
//  Course
//
//  Created by Cedric on 2016/12/8.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit

class CourseMainViewController: UIViewController, UIPageViewControllerDataSource {
    
    var PageViewController:CoursePageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            let dayid = daycontroller.getdayID()
            
            switch dayid {
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
            default:
                return nil
            }
            
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
}

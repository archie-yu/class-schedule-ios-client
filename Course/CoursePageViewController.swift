//
//  CoursePageViewController.swift
//  Course
//
//  Created by Cedric on 2016/12/5.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit

class CoursePageViewController: UIPageViewController {
    
    var mondayController : DisplayCoursesViewController?
    
    var tuesdayController : DisplayCoursesViewController?
    
    var wednesdayController : DisplayCoursesViewController?
    
    var thursdayController : DisplayCoursesViewController?
    
    var fridayController : DisplayCoursesViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        mondayController = storyboard?.instantiateViewController(withIdentifier: "DayCourse") as? DisplayCoursesViewController
        mondayController?.dayID = 1
        
        tuesdayController = storyboard?.instantiateViewController(withIdentifier: "DayCourse") as? DisplayCoursesViewController
        tuesdayController?.dayID = 2
        
        wednesdayController = storyboard?.instantiateViewController(withIdentifier: "DayCourse") as? DisplayCoursesViewController
        wednesdayController?.dayID = 3
        
        thursdayController = storyboard?.instantiateViewController(withIdentifier: "DayCourse") as? DisplayCoursesViewController
        thursdayController?.dayID = 4
        
        fridayController = storyboard?.instantiateViewController(withIdentifier: "DayCourse") as? DisplayCoursesViewController
        fridayController?.dayID = 5
        
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
    
    func add_Course(){
        for course in courseList{
            if(course.isNew == true){
                switch course.date{
                    case "Mon":
                        mondayController?.addCourse(course: course)
                        break
                    case "Tue":
                        tuesdayController?.addCourse(course: course)
                        break
                    case "Wes":
                        wednesdayController?.addCourse(course: course)
                        break
                    case "Thu":
                        thursdayController?.addCourse(course: course)
                        break
                    case "Fri":
                        fridayController?.addCourse(course: course)
                        break
                default:
                    break
                }
                course.isNew = false
            }
        }
    }
}
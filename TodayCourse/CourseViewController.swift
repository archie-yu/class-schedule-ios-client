//
//  TodayViewController.swift
//  TodayCourse
//
//  Created by Archie Yu on 2017/1/10.
//  Copyright © 2017年 Archie Yu. All rights reserved.
//

import UIKit
import NotificationCenter
import CourseModel

class CourseViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var todayCourseTable: UITableView!
    
    var courseList : [CourseModel] = []
    var todayCourseList : [CourseModel] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view from its nib.
        todayCourseTable.delegate = self
        todayCourseTable.dataSource = self
        
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
            // Fallback on earlier versions
        }
        
        let filePath = courseDataFilePath()
        if (FileManager.default.fileExists(atPath: filePath)) {
            courseList = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! [CourseModel]
        }

        let curDate = Date()
        let calendar = Calendar.current
        let weekday = calendar.dateComponents([.weekday], from: curDate).weekday
        for course in courseList {
            if course.weekday == weekday {
                todayCourseList.append(course)
            }
        }
        
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .compact:
            self.preferredContentSize = CGSize(
                width: self.view.bounds.size.width,
                height: 37 * 3)
        case .expanded:
            self.preferredContentSize = CGSize(
                width: self.view.bounds.size.width,
                height: CGFloat(37 * (todayCourseList.count > 6 ? todayCourseList.count : 6)))
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayCourseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayCourseCell", for: indexPath) as! CourseCell
        
        let course = todayCourseList[indexPath.row]
        cell.courseName.text = "\(course.course)(\(course.location))"
        cell.courseTime.text = "\(course.begin) - \(course.end)"
        
        return cell
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}

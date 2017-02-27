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
    
    var courseList: [Course] = []
    var todayLessonList: [Lesson] = []
    
    var isOldVersion = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view from its nib.
        todayCourseTable.delegate = self
        todayCourseTable.dataSource = self
        
        let filePath = courseDataFilePath()
        if (FileManager.default.fileExists(atPath: filePath)) {
            courseList = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! [Course]
        }

        let curDate = Date()
        let calendar = Calendar.current
        let weekday = (calendar.dateComponents([.weekday], from: curDate).weekday! + 5) % 7
        for course in courseList {
            for lesson in course.lessons {
                if lesson.weekday == weekday {
                    todayLessonList.append(lesson)
                }
            }
        }
        todayLessonList.sort() { $0.firstClass < $1.firstClass }
        
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
            isOldVersion = true
            self.preferredContentSize = CGSize(width: 0, height: CGFloat(37 * (todayLessonList.count > 3 ? todayLessonList.count : 3) - 1))
        }
        
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.zero
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
                height: CGFloat(37 * (todayLessonList.count > 6 ? todayLessonList.count : 6)))
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayLessonList.count > 6 ? todayLessonList.count : 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayCourseCell", for: indexPath) as! CourseCell
        
        if isOldVersion {
            cell.courseName.textColor = .white
            cell.courseTime.textColor = .white
        }
        
        if indexPath.row >= todayLessonList.count {
            cell.courseName.text = ""
            cell.courseTime.text = ""
        } else {
            let lesson = todayLessonList[indexPath.row]
            cell.courseName.text = "\(lesson.course)(\(lesson.room))"
            cell.courseTime.text = "\(lesson.firstClass) - \(lesson.lastClass)"
        }
        
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

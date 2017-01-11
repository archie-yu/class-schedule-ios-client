//
//  TodayViewController.swift
//  ThisWeekAssignment
//
//  Created by Archie Yu on 2017/1/10.
//  Copyright © 2017年 Archie Yu. All rights reserved.
//

import UIKit
import NotificationCenter
import CourseModel

var assignmentList : [AssignmentModel] = []

class WeekAssignmentViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
//    let weekday = ["Sun.", "Mon.", "Tue.", "Thur.", "Fri.", "Sat."]
    let weekday = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
    
    @IBOutlet weak var assignmentTable: UITableView!
    
    var weekAssignmentList : [AssignmentModel] = []
    
    func dataFilePath() -> String {
        let manager = FileManager()
        let containerURL = manager.containerURL(forSecurityApplicationGroupIdentifier: "group.cn.nju.edu.Course")
        return (containerURL?.appendingPathComponent("assignment.dat").path)!
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view from its nib.
        assignmentTable.delegate = self
        assignmentTable.dataSource = self
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        let filePath = dataFilePath()
        print(filePath)
        if (FileManager.default.fileExists(atPath: filePath)) {
            assignmentList = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! [AssignmentModel]
        }
        
        print(assignmentList.count)
        let current = Date()
        for assignment in assignmentList {
//            print(assignment.endTime.timeIntervalSince(current))
            if assignment.endTime.timeIntervalSince(current) < 60 * 60 * 24 * 7 {
                weekAssignmentList.append(assignment)
            }
        }
        
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .compact:
            self.preferredContentSize = CGSize(width: self.view.bounds.size.width, height: 37 * 3)
        case .expanded:
            self.preferredContentSize = CGSize(width: self.view.bounds.size.width, height: CGFloat(37 * (weekAssignmentList.count > 6 ? weekAssignmentList.count : 6)))
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekAssignmentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeekAssignmentCell", for: indexPath) as! WeekAssignmentCell
        
        if indexPath.row >= weekAssignmentList.count {
            cell.assignmentContent.text = ""
            cell.assignmentTime.text = ""
        } else {
            let assignment = weekAssignmentList[indexPath.row]
            cell.assignmentContent.text = assignment.course + "：" + assignment.content
            let calender = Calendar.current
            let dateComponents = calender.dateComponents([.weekday, .hour, .minute], from: assignment.endTime)
            cell.assignmentTime.text = weekday[dateComponents.weekday! - 1] + String(format: " %02d:%02d", dateComponents.hour!, dateComponents.minute!)
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

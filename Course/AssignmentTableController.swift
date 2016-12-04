//
//  SecondViewController.swift
//  Course
//
//  Created by Archie Yu on 2016/11/19.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit

class AssignmentTableController: UITableViewController {
    
    let identifier = "assignment"

    @IBOutlet var assignmentTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        assignmentTable.delegate = self
//        assignmentTable.dataSource = self
//        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        assignmentTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    var dataSourse = [("移动互联应用技术","App构思展示","Mon. 14:00"),
//                      ("计算机图形学","大作业第一阶段","Mon. 24:00")]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return assignmentList.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! AssignmentCell;
        
        cell.selectionStyle = .none
        
        cell.course.text = assignmentList[indexPath.row].courseName
        
        cell.assignment.text = assignmentList[indexPath.row].content
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "E HH:mm"
        cell.time.text = timeFormatter.string(from: assignmentList[indexPath.row].time)
        
        let alpha = ((CGFloat(assignmentList.count - indexPath.row)) / CGFloat(assignmentList.count)) * 0.5
        
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
        
        return cell;
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            assignmentList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAssignmentDetail" {
            let controller = segue.destination as! AssignmentDetailViewController
            controller.assignmentNo = (assignmentTable.indexPathForSelectedRow?.row)!
//            if let assignment = sender as? AssignmentCell {
//                controller.courseName = assignment.course.text!
//            }
        }
    }
    
}

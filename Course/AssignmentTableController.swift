//
//  SecondViewController.swift
//  Course
//
//  Created by Archie Yu on 2016/11/19.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import CourseModel

class AssignmentTableController: UITableViewController, MGSwipeTableCellDelegate {

    @IBOutlet var assignmentTable: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 载入保存的数据
        let filePath = assignmentDataFilePath()
        if (FileManager.default.fileExists(atPath: filePath)) {
            assignmentList = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! [Assignment]
        }
        
        // 注册应用程序进入后台的消息
        let app = UIApplication.shared
        let NC = NotificationCenter.default
        NC.addObserver(self,
                       selector: #selector(applicationWillResignActive(notification:)),
                       name: NSNotification.Name.UIApplicationWillResignActive,
                       object: app)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 添加新任务／载入数据后，刷新table的数据
        assignmentTable.reloadData()
    }
    
    func applicationWillResignActive(notification: NSNotification) {
        
        // 程序挂起前，保存数据
        let filePath = assignmentDataFilePath()
        NSKeyedArchiver.archiveRootObject(assignmentList, toFile: filePath)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func finishAssignment(at indexPath: IndexPath) {
        // 删除一项任务
        assignmentList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignmentList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignment", for: indexPath) as! AssignmentCell;
        
        // 计算按钮高度
        let height = cell.card.frame.size.height
        let deltaY = cell.frame.height - height
        
        let buttonRect = CGRect(x: 0, y: deltaY, width: 140, height: height)
        let cardRect = CGRect(x: 5, y: deltaY, width: 126, height: height)
        
        // 定义渐变灰色
        var rgb : CGFloat
        if assignmentList.count <= 6 {
            rgb = 1 - 0.06 * CGFloat(indexPath.row)
        }
        else {
            rgb = 1 - CGFloat(indexPath.row) / CGFloat(assignmentList.count - 1) * 0.36
        }
        let color = UIColor(red: rgb, green: rgb, blue: rgb, alpha: 1)
        
        // 生成'完成'按钮（透明）
        let finishButton = MGSwipeButton(frame: buttonRect)
        finishButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        // 定义'完成'按钮的回调函数，负责删除assignmentList中的数据，以及更新AssignmentTable
        finishButton.callback = { (cell) -> Bool in
            self.finishAssignment(at: self.tableView.indexPath(for: cell)!)
            return true
        }
        
        // 定义'完成'按钮的界面（圆角矩形卡片）
        let finishCard = UILabel(frame: cardRect)
        finishCard.backgroundColor = color
        finishCard.layer.cornerRadius = 3
        finishCard.clipsToBounds = true
        finishCard.text = "完成"
        finishCard.textColor = .darkGray
        finishCard.textAlignment = .center
        finishButton.addSubview(finishCard)
        
        // 将按钮添加到cell右侧
        cell.rightButtons = [finishButton]
        cell.rightSwipeSettings.transition = .drag
        
        /*  定义cell属性:
         *  颜色
         *  点击颜色
         *  文本
         */
        cell.card.backgroundColor = color
        cell.selectionStyle = .none
        cell.course.text = assignmentList[indexPath.row].course
        cell.assignment.text = assignmentList[indexPath.row].content
        let timeFormatter = DateFormatter()
        let curDate = Date()
        let endDate = assignmentList[indexPath.row].endTime
        let remainingSec = Int(endDate.timeIntervalSince(curDate))
        if remainingSec < 60 * 60 * 24 * 7 {
            timeFormatter.dateFormat = "E HH:mm"
            cell.time.text = timeFormatter.string(from: assignmentList[indexPath.row].endTime)
        } else {
            cell.time.text = String(format: "%d天后", remainingSec / 60 / 60 / 24)
        }
        
        return cell;
        
    }
    
    @IBAction func addAssignment(_ sender: UIBarButtonItem) {
        if courseList.count > 0 {
            self.performSegue(withIdentifier: "AddAssignment", sender: self)
        }
        else {
            let alertController = UIAlertController(title: "提示", message: "还没有添加任何课程！", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch(identifier) {
            case "ShowAssignmentDetail":
                let controller = segue.destination as! AssignmentDetailViewController
                controller.assignmentNo = (assignmentTable.indexPathForSelectedRow?.row)!
            default: break
            }
        }
    }
    
}

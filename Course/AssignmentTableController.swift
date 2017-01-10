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
    
    let identifier = "assignment"

    @IBOutlet var assignmentTable: UITableView!
    
    func dataFilePath() -> String {
        let manager = FileManager()
        let containerURL = manager.containerURL(forSecurityApplicationGroupIdentifier: "group.cn.nju.edu.Course")
        return (containerURL?.appendingPathComponent("assignment.dat").path)!
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let filePath = dataFilePath()
        if (FileManager.default.fileExists(atPath: filePath)) {
            assignmentList = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! [AssignmentModel]
        }
        
        let app = UIApplication.shared
        // 第一个self参数，View Contoller实例会作为观察者接受通知。
        // 第二个参数将一个选择器传入applicationWillResignActive方法，告诉通知中心在发布该通知后调用这个方法。
        // 第三个参数UIApplicationWillResignActiveNotification，是接受通知的名称，他是由UIApplication类定义的字符串常量
        // 第四哥参数app是要从中获取通知的对象
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillResignActive(notification:)),
                                               name: NSNotification.Name.UIApplicationWillResignActive,
                                               object: app)
        
    }
    
    // 程序挂起前，保存数据
    func applicationWillResignActive(notification: NSNotification) {
        
        let filePath = dataFilePath()
        NSKeyedArchiver.archiveRootObject(assignmentList, toFile: filePath)
        
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
    
    func finishAssignment(at indexPath: IndexPath) {
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! AssignmentCell;
        
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
        cell.course.text = assignmentList[indexPath.row].courseName
        cell.assignment.text = assignmentList[indexPath.row].content
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "E HH:mm"
        cell.time.text = timeFormatter.string(from: assignmentList[indexPath.row].endTime)
        
        return cell;
        
    }
    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
//    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "完成"
//    }
    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let finish = UITableViewRowAction(style: .default, title: "完成") { (action, indexPath) in
//            assignmentList.remove(at: indexPath.row)
//        }
//        let delete = UITableViewRowAction(style: .destructive, title: "删除") { (action, indexPath) in
//            assignmentList.remove(at: indexPath.row)
//        }
//        finish.backgroundColor = .green
//        return [finish, delete]
//    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            assignmentList.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
//        }
//    }
    
//    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection, from point: CGPoint) -> Bool {
//        if direction == .rightToLeft {
//            return true
//        }
//        else {
//            return false
//        }
//    }
    
//    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
//        
//        swipeSettings.transition = .drag
//        expansionSettings.buttonIndex = 0
//        
//        expansionSettings.fillOnTrigger = true;
//        expansionSettings.threshold = 1.1;
//        let padding = 15
//        let bgColor = UIColor.green
//        return [
//            MGSwipeButton(title: "完成", backgroundColor: bgColor, padding: padding, callback: { (cell) -> Bool in
//                return false; //don't autohide to improve delete animation
//            })
//        ]
//        
//    }
    
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
            default: break;
            }
        }
    }
    
}

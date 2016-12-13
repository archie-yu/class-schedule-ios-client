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
    
    func dataFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        return documentsDirectory.appendingPathComponent("assignment.dat") as String
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
//        assignmentTable.delegate = self
//        assignmentTable.dataSource = self
//        self.hidesBottomBarWhenPushed = true
        
        let filePath = dataFilePath()
//        print("check file")
        //检查数据文件是否存在：不存在就不加载，存在就用该文件的内容实例化数组，并将数组中的对象复制到4个文本框。
        if (FileManager.default.fileExists(atPath: filePath)) {
//            print("read file")
            assignmentList = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! [AssignmentModel]
        }
        
        let app = UIApplication.shared
        //第一个self参数，View Contoller实例会作为观察者接受通知。
        //第二个参数将一个选择器传入applicationWillResignActive方法，告诉通知中心在发布该通知后调用这个方法。
        //第三个参数UIApplicationWillResignActiveNotification，是接受通知的名称，他是由UIApplication类定义的字符串常量
        //第四哥参数app是要从中获取通知的对象
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillResignActive(notification:)),
                                               name: NSNotification.Name.UIApplicationWillResignActive,
                                               object: app)
        
    }
    
    //通过调用lineFields数组中每个文本框的text方法构建一个字符串数组，调用valueForKey方法，传递文本text作为参数。
    //NSArray类的valueForKey方法实现了迭代获取UITextField实例变量的text值，返回包含这些值的NSString。
    func applicationWillResignActive(notification: NSNotification) {
        
//        print("save file")
        
//        let array = (assignmentList as NSArray)
//        array.write(toFile: filePath, atomically: true)
        
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return assignmentList.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! AssignmentCell;
        
        cell.selectionStyle = .none
        
        var color : CGFloat
        if assignmentList.count == 1 {
            color = 1
        }
        else {
            color = 1 - CGFloat(indexPath.row) / CGFloat(assignmentList.count - 1) * 0.25
        }
        cell.card.backgroundColor = UIColor(red: color, green: color, blue: color, alpha: 1)
        
        cell.course.text = assignmentList[indexPath.row].courseName
        
        cell.assignment.text = assignmentList[indexPath.row].content
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "E HH:mm"
        cell.time.text = timeFormatter.string(from: assignmentList[indexPath.row].endTime)
        
//        let alpha = ((CGFloat(assignmentList.count - indexPath.row)) / CGFloat(assignmentList.count)) * 0.5
//        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
        
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
                //            if let assignment = sender as? AssignmentCell {
                //                controller.courseName = assignment.course.text!
                //            }
            default: break;
            }
        }
    }
    
}

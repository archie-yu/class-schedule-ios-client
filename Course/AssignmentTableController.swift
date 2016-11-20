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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var dataSourse = [("移动互联应用技术","App构思展示","Mon. 14:00"),
                      ("计算机图形学","大作业第一阶段","Mon. 24:00")]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourse.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! AssignmentCell;
        
        cell.course.text = dataSourse[indexPath.row].0
        cell.assignment.text = dataSourse[indexPath.row].1
        cell.time.text = dataSourse[indexPath.row].2
        
        let alpha = ((CGFloat(dataSourse.count - indexPath.row)) / CGFloat(dataSourse.count)) * 0.5
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
        
        return cell;
    }
    
}


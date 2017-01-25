//
//  TimeSettingsViewController.swift
//  Course
//
//  Created by Archie Yu on 2017/1/14.
//  Copyright © 2017年 Archie Yu. All rights reserved.
//

import UIKit

class TimeSettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        (self.view as! UITableView).separatorColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isUserInteractionEnabled = (sunday != 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return 2
        case 1: return 1
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSettingsCell", for: indexPath)
        
        cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
        cell.textLabel?.textColor = .white
        let selectedColor = UIColor(white: 1, alpha: 0.3)
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = selectedColor
        cell.selectedBackgroundView = selectedBackground
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if saturday == 0 {
                    cell.accessoryType = .none
                } else {
                    cell.accessoryType = .checkmark
                }
                cell.textLabel?.text = "周六"
            case 1:
                if sunday == 0 {
                    cell.accessoryType = .none
                } else {
                    cell.accessoryType = .checkmark
                }
                cell.textLabel?.text = "周日"
            default: break
            }
        case 1:
            cell.accessoryType = .none
            cell.textLabel?.text = "总周数"
        default: break
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 取消选中
        tableView.deselectRow(at: indexPath, animated: true)
        
        let userDefault = UserDefaults(suiteName: "group.cn.nju.edu.Course")
        
        // 跳转
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if saturday == 1 {
                    tableView.cellForRow(at: indexPath)?.accessoryType = .none
                    saturday = 0
                    userDefault?.set(0, forKey: "Saturday")
                } else {
                    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    saturday = 1
                    userDefault?.set(1, forKey: "Saturday")
                }
            case 1:
                let saturdayCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
                if sunday == 1 {
                    saturdayCell?.isUserInteractionEnabled = true
                    tableView.cellForRow(at: indexPath)?.accessoryType = .none
                    sunday = 0
                    userDefault?.set(0, forKey: "Sunday")
                } else {
                    saturdayCell?.accessoryType = .checkmark
                    saturdayCell?.isUserInteractionEnabled = false
                    saturday = 1
                    userDefault?.set(1, forKey: "Saturday")
                    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    sunday = 1
                    userDefault?.set(1, forKey: "Sunday")
                }
            default: break
            }
            weekdayNum = 5 + saturday + sunday
            needReload = true
        case 2: break
        default: break
        }
        
        userDefault?.synchronize()
        
    }

}

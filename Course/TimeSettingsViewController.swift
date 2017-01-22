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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        (self.view as! UITableView).separatorColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch(section) {
        case 0: return 2
        case 1: return 1
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSettingsCell", for: indexPath)
        
        // Configure the cell...
        
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
                    userDefault?.set(false, forKey: "Saturday")
                } else {
                    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    saturday = 1
                    userDefault?.set(true, forKey: "Saturday")
                }
            case 1:
                let saturdayCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
                if sunday == 1 {
                    saturdayCell?.isUserInteractionEnabled = true
                    tableView.cellForRow(at: indexPath)?.accessoryType = .none
                    sunday = 0
                    userDefault?.set(false, forKey: "Sunday")
                } else {
                    saturdayCell?.accessoryType = .checkmark
                    saturdayCell?.isUserInteractionEnabled = false
                    saturday = 1
                    userDefault?.set(true, forKey: "Saturday")
                    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    sunday = 1
                    userDefault?.set(true, forKey: "Sunday")
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

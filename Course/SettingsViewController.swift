//
//  SettingsViewController.swift
//  Course
//
//  Created by Archie Yu on 2016/12/14.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

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
        case 1: return 2
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    /*
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .black
        return header
    }
    */
    
    /*
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .black
        return footer
    }
    */

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)

        // Configure the cell...
        
        cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        
        cell.textLabel?.textColor = .white
        
        switch indexPath.section {
        case 0:
            cell.selectionStyle = .none
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "黑色主题"
                let themeSwitch = UISwitch()
                let cellSize = cell.frame.size
                let switchSize = themeSwitch.frame.size
                let rect = CGRect(x: cellSize.width - switchSize.width - 15, y: (cellSize.height - switchSize.height) / 2, width: switchSize.width, height: switchSize.height)
                themeSwitch.frame = rect
                themeSwitch.onTintColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
                themeSwitch.setOn(true, animated: false)
                cell.addSubview(themeSwitch)
            case 1:
                cell.textLabel?.text = ""
            default:
                break
            }
        case 1:
            cell.accessoryType = .disclosureIndicator
            
            let selectedColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
            let selectedBackground = UIView()
            selectedBackground.backgroundColor = selectedColor
            cell.selectedBackgroundView = selectedBackground
            
            switch indexPath.row {
            case 0: cell.textLabel?.text = "反馈"
            case 1: cell.textLabel?.text = "关于"
            default: break
            }
        default:
            break
        }
        
        return cell
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 取消选中
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 跳转
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0: break
            case 1: performSegue(withIdentifier: "ShowAbout", sender: self)
            default: break
            }
            
        default: break
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SettingsViewController.swift
//  Course
//
//  Created by Archie Yu on 2016/12/14.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        (self.view as! UITableView).separatorColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch(section) {
        case 0: return 2
        case 1: return 1
        case 2: return 2
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        
        cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        cell.textLabel?.textColor = .white
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "课程时间"
                cell.accessoryType = .disclosureIndicator
                let selectedColor = UIColor(white: 1, alpha: 0.3)
                let selectedBackground = UIView()
                selectedBackground.backgroundColor = selectedColor
                cell.selectedBackgroundView = selectedBackground
            case 1:
                cell.textLabel?.text = "黑色主题"
                cell.selectionStyle = .none
                let themeSwitch = UISwitch()
                let cellSize = cell.frame.size
                let switchSize = themeSwitch.frame.size
                let rect = CGRect(x: cellSize.width - switchSize.width - 15, y: (cellSize.height - switchSize.height) / 2, width: switchSize.width, height: switchSize.height)
                themeSwitch.frame = rect
                themeSwitch.onTintColor = UIColor(red: 80 / 255, green: 227 / 255, blue: 194 / 255, alpha: 0.85)
                themeSwitch.setOn(true, animated: false)
                cell.addSubview(themeSwitch)
                themeSwitch.isEnabled = false
            default:
                break
            }
        case 1:
            cell.textLabel?.text = "iCloud同步"
            cell.selectionStyle = .none
            let icloudSwitch = UISwitch()
            let cellSize = cell.frame.size
            let switchSize = icloudSwitch.frame.size
            let rect = CGRect(x: cellSize.width - switchSize.width - 15, y: (cellSize.height - switchSize.height) / 2, width: switchSize.width, height: switchSize.height)
            icloudSwitch.frame = rect
            icloudSwitch.onTintColor = UIColor(red: 80 / 255, green: 227 / 255, blue: 194 / 255, alpha: 0.85)
            icloudSwitch.setOn(false, animated: false)
            cell.addSubview(icloudSwitch)
            icloudSwitch.isEnabled = false
        case 2:
            switch indexPath.row {
            case 0: cell.textLabel?.text = "反馈"
            case 1: cell.textLabel?.text = "关于"
            default: break
            }
            cell.accessoryType = .disclosureIndicator
            let selectedColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
            let selectedBackground = UIView()
            selectedBackground.backgroundColor = selectedColor
            cell.selectedBackgroundView = selectedBackground
        default:
            break
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 取消选中
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 跳转
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: performSegue(withIdentifier: "EditCourseTime", sender: self)
            default: break
            }
        case 2:
            switch indexPath.row {
            case 0:
                if MFMailComposeViewController.canSendMail() {
                    // 注意这个实例要写在 if block 里，否则无法发送邮件时会出现两次提示弹窗（一次是系统的）
                    let mailComposeViewController = configuredMailComposeViewController()
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
            case 1: performSegue(withIdentifier: "ShowAbout", sender: self)
            default: break
            }
            
        default: break
        }
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        
        let infoDic = Bundle.main.infoDictionary
        // 获取 App 的版本号
        let appVersion = (infoDic?["CFBundleShortVersionString"])!
        
        // 获取设备的型号
        let modelName = UIDevice.current.modelName
        // 获取系统版本号
        let systemVersion = UIDevice.current.systemVersion
        
        // 设置邮件地址、主题及正文
        mailComposeVC.setToRecipients(["slothstudio@126.com"])
        mailComposeVC.setSubject("Course 意见反馈")
        mailComposeVC.setMessageBody("< 反馈内容 >\n\n\n 应用名称：Course\n 应用版本：\(appVersion)\n 设备型号：\(modelName)\n 系统版本：\(systemVersion)", isHTML: false)
        
        return mailComposeVC
        
    }
    
    func showSendMailErrorAlert() {
        
        let sendMailErrorAlert = UIAlertController(title: "无法发送邮件", message: "您的设备尚未设置邮箱，请在“邮件”应用中设置后再尝试发送。", preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "确定", style: .default) { _ in })
        self.present(sendMailErrorAlert, animated: true){}
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
//        switch result {
//        case .cancelled:
//            print("取消发送")
//        case .sent:
//            print("发送成功")
//        default:
//            break
//        }
        self.dismiss(animated: true, completion: nil)
        
    }

}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,3", "iPhone8,4":                  return "iPhone SE"
        case "iPhone9,1":                               return "iPhone 7"
        case "iPhone9,2":                               return "iPhone 7 Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

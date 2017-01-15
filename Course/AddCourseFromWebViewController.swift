//
//  AddCourseFromWebViewController.swift
//  Course
//
//  Created by Archie Yu on 2017/1/13.
//  Copyright © 2017年 Archie Yu. All rights reserved.
//

import UIKit
import CourseModel

class AddCourseFromWebViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userLabel: UITextField!
    @IBOutlet weak var passLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userLabel.delegate = self
        passLabel.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func GetRequest()
    {
        // 创建请求对象
        let username = userLabel.text!
        let password = passLabel.text!
        let urlStr = "http://115.159.208.82/username=\(username)&password=\(password)"
        let url = URL(string: urlStr)
        var request = URLRequest(url: url!)
        
//        let paramStr = "username=\(username)&password=\(password)"
//        let paraData = paramStr.data(using: String.Encoding.utf8)
        
        // 设置请求体
        request.httpMethod = "GET"
//        request.httpBody = paraData
        
        // 发送请求
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let e = error {
                print(e)
            }
            // 服务器返回：请求方式 = GET，返回数据格式 = JSON
            if let d = data {
                let dataStr = String(data: d, encoding: .utf8)
                let offset = dataStr?.range(of: "[")?.lowerBound
                let rawData = dataStr?.substring(from: offset!).data(using: .utf8)
//                print(String(data: rawData!, encoding: .utf8))
                let jsonArr = try! JSONSerialization.jsonObject(
                    with: rawData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: Any]]
                for json in jsonArr {
                    let course = json["Course"] as! String
                    let teacher = json["Teacher"] as! String
                    let location = json["Location"] as! String
                    let weekday = json["Weekday"] as! Int
                    let begin = json["Begin"] as! Int
                    let end = json["End"] as! Int
                    let firstWeek = json["FirstWeek"] as! Int
                    let lastWeek = json["LastWeek"] as! Int
                    let interval = json["Interval"] as! Int
                    courseFromWebList.append(CourseModel(course: course, teacher: teacher, in: location, on: weekday, from: begin, to: end, fromWeek: firstWeek, toWeek: lastWeek, limit: interval))
                }
                DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: "ShowCourseFromWeb", sender: self)
                })
            }
        }
        
        task.resume()
    
    }

    @IBAction func login(_ sender: UIButton) {
        GetRequest()
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

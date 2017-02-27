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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fetchingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if userLabel.text != "" && passLabel.text != "" {
            loginButton.alpha = 1
            loginButton.isEnabled = true
        } else {
            loginButton.alpha = 0.5
            loginButton.isEnabled = false
        }
    }
    
    func GetRequest()
    {
        
        fetchingIndicator.startAnimating()
        
        // 创建请求对象
        let username = userLabel.text!
        let password = passLabel.text!
        let urlStr = "http://115.159.208.82/username=\(username)&password=\(password)"
        let url = URL(string: urlStr)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        // 发送请求
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                sleep(1)
                let alertController = UIAlertController(title: "错误", message: "连接至服务器失败", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "确定", style: .default, handler: nil)
                alertController.addAction(confirmAction)
                self.present(alertController, animated: true, completion: nil)
                DispatchQueue.main.async(execute: {
                    self.fetchingIndicator.stopAnimating()
                })
            } else if let d = data {
                let dataStr = String(data: d, encoding: .utf8)
                let offset = dataStr?.range(of: "[")?.lowerBound
                let rawData = dataStr?.substring(from: offset!).data(using: .utf8)
                let courseJsonArr = try! JSONSerialization.jsonObject(
                    with: rawData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: Any]]
                for courseJson in courseJsonArr {
                    let course = courseJson["course"] as! String
                    let teacher = courseJson["teacher"] as! String
                    let newCourse = Course(course: course, teacher: teacher)
                    var newLessons: [Lesson] = []
                    let lessonJsonArr = courseJson["lessons"] as! [[String: Any]]
                    for lessonJson in lessonJsonArr {
                        let room = lessonJson["room"] as! String
                        let weekday = lessonJson["weekday"] as! Int
                        let firstClass = lessonJson["first_class"] as! Int
                        let lastClass = lessonJson["last_class"] as! Int
                        let firstWeek = lessonJson["first_week"] as! Int
                        let lastWeek = lessonJson["last_week"] as! Int
                        let alternate = lessonJson["alternate"] as! Int
                        newLessons.append(Lesson(course: course, inRoom: room, fromWeek: firstWeek, toWeek: lastWeek, alternate: alternate, on: weekday, fromClass: firstClass, toClass: lastClass))
                    }
                    courseFromWebList.append(newCourse)
                    lessonFromWebList.append(newLessons)
                }
                DispatchQueue.main.async(execute: {
                    self.fetchingIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "ShowCourseFromWeb", sender: self)
                })
            }
        }
        
        task.resume()
    
    }
    
    @IBAction func login(_ sender: UIButton) {
        GetRequest()
    }
    
}

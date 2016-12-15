//
//  AssignmentModel.swift
//  Course
//
//  Created by Archie Yu on 2016/12/4.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import Foundation

var assignmentList : [AssignmentModel] = []

class AssignmentModel : NSObject, NSCoding {
    
    var courseName : String
    var content : String
    var beginTime : Date
    var endTime : Date
    
    init(_ courseName : String, _ content : String, _ time : Date) {
        self.courseName = courseName
        self.content = content
        beginTime = Date()
        endTime = time
    }
    
    func encode(with: NSCoder){
        with.encode(courseName, forKey: "name")
        with.encode(content, forKey: "content")
        with.encode(beginTime, forKey: "begin")
        with.encode(endTime, forKey: "end")
    }
    
    required init?(coder: NSCoder) {
        courseName = coder.decodeObject(forKey: "name") as! String
        content = coder.decodeObject(forKey: "content") as! String
        beginTime = coder.decodeObject(forKey: "begin") as! Date
        endTime = coder.decodeObject(forKey: "end") as! Date
    }
    
}

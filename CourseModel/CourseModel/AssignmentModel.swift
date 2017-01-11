//
//  AssignmentModel.swift
//  CourseModel
//
//  Created by Archie Yu on 2017/1/10.
//  Copyright © 2017年 Archie Yu. All rights reserved.
//

import Foundation

public class AssignmentModel : NSObject, NSCoding {
    
    public var courseName : String
    public var content : String
    public var beginTime : Date
    public var endTime : Date
    
    public init(in courseName : String, todo content : String, from beginTime : Date, to endTime : Date) {
        self.courseName = courseName
        self.content = content
        self.beginTime = beginTime
        self.endTime = endTime
    }
    
    public func encode(with: NSCoder){
        with.encode(courseName, forKey: "name")
        with.encode(content, forKey: "content")
        with.encode(beginTime, forKey: "begin")
        with.encode(endTime, forKey: "end")
    }
    
    required public init?(coder: NSCoder) {
        courseName = coder.decodeObject(forKey: "name") as! String
        content = coder.decodeObject(forKey: "content") as! String
        beginTime = coder.decodeObject(forKey: "begin") as! Date
        endTime = coder.decodeObject(forKey: "end") as! Date
    }
    
}

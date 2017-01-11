//
//  CourseModel.swift
//  CourseModel
//
//  Created by Archie Yu on 2017/1/11.
//  Copyright © 2017年 Archie Yu. All rights reserved.
//

import Foundation

public class CourseModel : NSObject, NSCoding {
    
    public var course: String
    public var teacher: String
    public var location: String
    public var weekday: Int
    public var begin: Int
    public var end: Int
    
    public init(course: String, teacher: String, in location:String, on weekday: Int, from begin: Int, to end: Int) {
        self.course = course
        self.teacher = teacher
        self.location = location
        self.weekday = weekday
        self.begin = begin
        self.end = end
    }
    
    public func encode(with: NSCoder){
        with.encode(course, forKey: "course")
        with.encode(teacher, forKey: "teacher")
        with.encode(location, forKey: "location")
        with.encode(weekday, forKey: "weekday")
        with.encode(begin, forKey: "begin")
        with.encode(end, forKey: "end")
    }
    
    required public init?(coder: NSCoder) {
        course = coder.decodeObject(forKey: "course") as! String
        teacher = coder.decodeObject(forKey: "teacher") as! String
        location = coder.decodeObject(forKey: "location") as! String
        weekday = coder.decodeInteger(forKey: "weekday")
        begin = coder.decodeInteger(forKey: "begin")
        end = coder.decodeInteger(forKey: "end")
    }
    
}

public func courseDataFilePath() -> String {
    let manager = FileManager()
    let containerURL = manager.containerURL(forSecurityApplicationGroupIdentifier: "group.cn.nju.edu.Course")
    return (containerURL?.appendingPathComponent("course.dat").path)!
}

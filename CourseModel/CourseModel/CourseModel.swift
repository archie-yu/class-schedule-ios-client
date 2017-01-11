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
    public var day: Int
    public var begin: Int
    public var end: Int
    
    public init(course: String, teacher: String, in location:String, on day: Int, from begin: Int, to end: Int) {
        self.course = course
        self.teacher = teacher
        self.location = location
        self.day = day
        self.begin = begin
        self.end = end
    }
    
    public func encode(with: NSCoder){
        with.encode(course, forKey: "course")
        with.encode(teacher, forKey: "teacher")
        with.encode(location, forKey: "location")
        with.encode(day, forKey: "day")
        with.encode(begin, forKey: "begin")
        with.encode(end, forKey: "end")
    }
    
    required public init?(coder: NSCoder) {
        course = coder.decodeObject(forKey: "course") as! String
        teacher = coder.decodeObject(forKey: "teacher") as! String
        location = coder.decodeObject(forKey: "location") as! String
        day = coder.decodeObject(forKey: "day") as! Int
        begin = coder.decodeObject(forKey: "begin") as! Int
        end = coder.decodeObject(forKey: "end") as! Int
    }
    
}

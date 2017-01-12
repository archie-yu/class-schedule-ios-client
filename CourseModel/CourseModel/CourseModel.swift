//
//  CourseModel.swift
//  CourseModel
//
//  Created by Archie Yu on 2017/1/11.
//  Copyright © 2017年 Archie Yu. All rights reserved.
//

import Foundation

// 保存课程信息的单元
public class CourseModel : NSObject, NSCoding {
    
    public var course: String
    public var teacher: String
    public var location: String
    public var weekday: Int
    public var begin: Int
    public var end: Int
    public var weekBegin: Int
    public var weekEnd: Int
    //0:single week 1:double week 2:everyweek
    public var weekLimit: Int
    
    public init(course: String, teacher: String, in location:String, on weekday: Int, from begin: Int, to end: Int,fromWeek weekBegin:Int,toWeek weekEnd:Int,limit weekLimit: Int) {
        self.course = course
        self.teacher = teacher
        self.location = location
        self.weekday = weekday
        self.begin = begin
        self.end = end
        self.weekBegin = weekBegin
        self.weekEnd = weekEnd
        self.weekLimit = weekLimit
    }
    
    public func encode(with: NSCoder){
        with.encode(course, forKey: "course")
        with.encode(teacher, forKey: "teacher")
        with.encode(location, forKey: "location")
        with.encode(weekday, forKey: "weekday")
        with.encode(begin, forKey: "begin")
        with.encode(end, forKey: "end")
        with.encode(weekBegin,forKey: "weekBegin")
        with.encode(weekEnd,forKey: "weekEnd")
        with.encode(weekLimit,forKey: "weekLimit")
    }
    
    required public init?(coder: NSCoder) {
        course = coder.decodeObject(forKey: "course") as! String
        teacher = coder.decodeObject(forKey: "teacher") as! String
        location = coder.decodeObject(forKey: "location") as! String
        weekday = coder.decodeInteger(forKey: "weekday")
        begin = coder.decodeInteger(forKey: "begin")
        end = coder.decodeInteger(forKey: "end")
        weekBegin = coder.decodeInteger(forKey: "weekBegin")
        weekEnd = coder.decodeInteger(forKey: "weekEnd")
        weekLimit = coder.decodeInteger(forKey: "weekLimit")
    }
    
}

// 获取共享空间中保存课程信息的文件地址
public func courseDataFilePath() -> String {
    let manager = FileManager()
    let containerURL = manager.containerURL(forSecurityApplicationGroupIdentifier: "group.cn.nju.edu.Course")
    return (containerURL?.appendingPathComponent("course.dat").path)!
}

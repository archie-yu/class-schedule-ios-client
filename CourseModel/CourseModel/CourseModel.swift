//
//  CourseModel.swift
//  CourseModel
//
//  Created by Archie Yu on 2017/1/11.
//  Copyright © 2017年 Archie Yu. All rights reserved.
//

import Foundation

public class Lesson: NSObject, NSCoding {
    
    public var course: String
    public var room: String
    public var firstWeek: Int
    public var lastWeek: Int
    public var alternate: Int // every: 11, odd: 01, even: 10
    public var weekday: Int
    public var firstClass: Int
    public var lastClass: Int
    
    public init(course: String, inRoom: String, fromWeek: Int, toWeek: Int, alternate: Int, on: Int, fromClass: Int, toClass: Int) {
        self.course = course
        room = inRoom
        switch alternate {
        case 1:
            firstWeek = fromWeek / 2 * 2 + 1
            lastWeek = toWeek / 2 * 2 - 1
        case 2:
            firstWeek = (fromWeek + 1) / 2 * 2
            lastWeek = (toWeek - 1) / 2 * 2
        default:
            firstWeek = fromWeek
            lastWeek = toWeek
        }
        self.alternate = alternate
        weekday = on
        firstClass = fromClass
        lastClass = toClass
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(course, forKey: "course")
        aCoder.encode(room, forKey: "room")
        aCoder.encode(firstWeek, forKey: "firstWeek")
        aCoder.encode(lastWeek, forKey: "lastWeek")
        aCoder.encode(alternate, forKey: "alternate")
        aCoder.encode(weekday, forKey: "weekday")
        aCoder.encode(firstClass, forKey: "firstClass")
        aCoder.encode(lastClass, forKey: "lastClass")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        course = aDecoder.decodeObject(forKey: "course") as! String
        room = aDecoder.decodeObject(forKey: "room") as! String
        firstWeek = aDecoder.decodeInteger(forKey: "firstWeek")
        lastWeek = aDecoder.decodeInteger(forKey: "lastWeek")
        alternate = aDecoder.decodeInteger(forKey: "alternate")
        weekday = aDecoder.decodeInteger(forKey: "weekday")
        firstClass = aDecoder.decodeInteger(forKey: "firstClass")
        lastClass = aDecoder.decodeInteger(forKey: "lastClass")
    }
    
    public func conflict(with lesson: Lesson) -> Bool {
        let weekConflict = ((firstWeek >= lesson.firstWeek && firstWeek <= lesson.lastWeek) || (lastWeek >= lesson.firstWeek && lastWeek <= lesson.lastWeek)) && (alternate & lesson.alternate != 0)
        let weekdayConflict = weekday == lesson.weekday
        let classConflict = (firstClass >= lesson.firstClass && firstClass <= lesson.lastClass) || (lastClass >= lesson.firstClass && lastClass <= lesson.lastClass)
        return  weekConflict && weekdayConflict && classConflict
    }
    
}

public class Course: NSObject, NSCoding {
    
    public var course: String
    public var teacher: String
    public var lessons: [Lesson]
    public var note: String
    
    public init(course: String, teacher: String) {
        self.course = course
        self.teacher = teacher
        lessons = []
        note = ""
    }
    
    public func encode(with aCoder: NSCoder){
        aCoder.encode(course, forKey: "course")
        aCoder.encode(teacher, forKey: "teacher")
        aCoder.encode(lessons, forKey: "lessons")
        aCoder.encode(note,forKey: "note")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        course = aDecoder.decodeObject(forKey: "course") as! String
        teacher = aDecoder.decodeObject(forKey: "teacher") as! String
        lessons = aDecoder.decodeObject(forKey: "lessons") as! [Lesson]
        note = aDecoder.decodeObject(forKey: "note") as! String
    }
    
    public func add(lesson newLesson: Lesson) -> Bool {
        for lesson in self.lessons {
            if lesson.conflict(with: newLesson) {
                return false
            }
        }
        self.lessons.append(newLesson)
        return true
    }
}

public func courseDataFilePath() -> String {
    let manager = FileManager()
    let containerURL = manager.containerURL(forSecurityApplicationGroupIdentifier: "group.cn.nju.edu.Course")
    return (containerURL?.appendingPathComponent("course.dat").path)!
}

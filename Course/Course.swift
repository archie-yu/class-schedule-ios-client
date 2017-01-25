//
//  CourseModel.swift
//  Course
//
//  Created by Archie Yu on 2016/11/28.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import Foundation
import CourseModel

var saturday = 0
var sunday = 0
var weekdayNum = 5 + saturday + sunday
var needReload = true

var courseNum = 11

var weekNum = 18
var currentWeek = 1
var realWeek = 0

let weekdayStrings = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]

var courseList: [Course] = []
var lessonList: [[Lesson]] = [[], [], [], [], [], [], []]

func add(course newCourse: Course) {
    for course in courseList {
        if course.course == newCourse.course {
            return
        }
    }
    courseList.append(newCourse)
}

func add(lesson newLesson: Lesson) -> Bool {
    for course in courseList {
        if course.course == newLesson.course {
            if course.add(lesson: newLesson) {
                lessonList[newLesson.weekday].append(newLesson)
                let filePath = courseDataFilePath()
                NSKeyedArchiver.archiveRootObject(courseList, toFile: filePath)
                return true
            }
            return false
        }
    }
    return false
}

func load(from filePath: String) {
    if (FileManager.default.fileExists(atPath: filePath)) {
        courseList = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! [Course]
    }
    for course in courseList {
        for lesson in course.lessons {
            lessonList[lesson.weekday].append(lesson)
        }
    }
}

var courseFromWebList: [Course] = []
var lessonFromWebList: [[Lesson]] = []

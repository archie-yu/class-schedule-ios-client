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
var courseWeek = 0
var relevantWeek = 0
var currenWeek = 0

func resumeWeek() {
    let userDefault = UserDefaults(suiteName: "group.cn.nju.edu.Course")
    courseWeek = userDefault!.integer(forKey: "CourseWeek")
    relevantWeek = userDefault!.integer(forKey: "RelevantWeek")
    if courseWeek == 0 {
        courseWeek = 1
        relevantWeek = Calendar.current.dateComponents([.weekOfYear], from: Date()).weekOfYear!
    } else {
        let currentWeek = Calendar.current.dateComponents([.weekOfYear], from: Date()).weekOfYear!
        courseWeek += currentWeek - relevantWeek
        if courseWeek > weekNum { courseWeek = weekNum }
    }
}

let weekdayStrings = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]

var courseList: [Course] = []
var lessonList: [[Lesson]] = [[], [], [], [], [], [], []]
var courseFromWebList: [Course] = []
var lessonFromWebList: [[Lesson]] = []

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
                if newLesson.firstWeek <= courseWeek && newLesson.lastWeek >= courseWeek && (newLesson.alternate == 3 || (newLesson.alternate % 2) == (courseWeek % 2)) {
                    lessonList[newLesson.weekday].append(newLesson)
                }
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
            if lesson.firstWeek <= courseWeek && lesson.lastWeek >= courseWeek && (lesson.alternate == 3 || (lesson.alternate % 2) == (courseWeek % 2)) {
                lessonList[lesson.weekday].append(lesson)
            }
        }
    }
    for i in 0..<lessonList.count {
        lessonList[i].sort() { $0.firstClass < $1.firstClass }
    }
}

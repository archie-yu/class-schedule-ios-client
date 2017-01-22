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

var courseList: [CourseModel] = []
var everydayCourseList: [[CourseModel]] = []

var courseFromWebList: [CourseModel] = []

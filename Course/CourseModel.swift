//
//  CourseModel.swift
//  Course
//
//  Created by Archie Yu on 2016/11/28.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import Foundation

var courseList : [CourseModel] = []

class CourseModel : NSObject {
    
    var courseName = "";
    var teacherName = "";
    var date = "";
    var begin_class = 1;
    var end_class = 2;
    var location = ""
    
    var isNew = true
    
    init(courseName : String,teacherName : String,location:String,date : String,begin_class:Int,end_class:Int) {
        self.courseName = courseName
        self.teacherName = teacherName
        self.date = date
        self.begin_class = begin_class
        self.end_class = end_class
        self.location = location
    }
    
}

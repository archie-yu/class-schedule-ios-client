//
//  AssignmentModel.swift
//  Course
//
//  Created by Archie Yu on 2016/12/4.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import Foundation

var assignmentList : [AssignmentModel] = []

class AssignmentModel {
    
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
    
}

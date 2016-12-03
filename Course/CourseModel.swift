//
//  CourseModel.swift
//  Course
//
//  Created by Archie Yu on 2016/11/28.
//  Copyright © 2016年 Archie Yu. All rights reserved.
//

import Foundation

var courseList : [CourseModel] = [.init("移动互联应用设计"), .init("概率论")]

class CourseModel : NSObject {
    
    var courseName = "";
    
    init(_ courseName : String) {
        self.courseName = courseName
    }
    
}

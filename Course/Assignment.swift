//
//  Assignment.swift
//  Course
//
//  Created by Archie Yu on 2017/1/10.
//  Copyright © 2017年 Archie Yu. All rights reserved.
//

import Foundation
import CourseModel

var assignmentList : [AssignmentModel] = []

func assignmentDataFilePath() -> String {
    let manager = FileManager()
    let containerURL = manager.containerURL(forSecurityApplicationGroupIdentifier: "group.cn.nju.edu.Course")
    return (containerURL?.appendingPathComponent("assignment.dat").path)!
}

//
//  My_AssignmentsApp.swift
//  My Assignments
//
//  Created by Ryan Madsen on 9/19/22.
//

import SwiftUI
import UIKit

let apiCaller = APICaller()

@main
struct My_AssignmentsApp: App {
    
    //    init(_ completion: @escaping () -> ()) {
    //        let enrollmentsURL: String = "https://canvas.instructure.com/api/v1/users/self/enrollments"
    //        let assignmentsURL: String = "https://canvas.instructure.com/api/v1/courses/"
    //        var assignments: [String] = []
    //
    //        let group = DispatchGroup()
    //
    //        group.enter()
    //        apiCaller.getEnrollments(strURL: enrollmentsURL, {
    //            group.enter()
    //            apiCaller.getCourseName(strURL: assignmentsURL, ids: apiCaller.courseIDs, {
    //                group.leave()
    //                print("done")
    //            })
    //            group.enter()
    //            apiCaller.getAssignments(strURL: assignmentsURL, ids: apiCaller.courseIDs, {
    //                group.leave()
    //                group.leave()
    //                print("done")
    //                for obj in apiCaller.courseAssignments.values {
    //                    for str in obj {
    //                        assignments.append(str)
    //                    }
    //                }
    //            })
    //
    //        })
    //
    //        group.notify(queue: .main, execute: {
    //            print("Completed")
    //            completion()})
    //        print("View Initialized")
    //    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

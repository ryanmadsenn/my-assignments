//
//  My_AssignmentsApp.swift
//  My Assignments
//
//  Created by Ryan Madsen on 9/19/22.
//

import SwiftUI
import UIKit

@main
struct My_AssignmentsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    public func callAPI(){
        guard let url = URL(string: "https://canvas.instructure.com/api/v1/courses") else{
            return
        }
        
        let APIkey = "x"

        var request = URLRequest(url: url)
        request.setValue(APIkey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in

            if let data = data {
                var decoded: [Object]?;
                typealias allObjects = [Object]?;
                do {
                    decoded = try JSONDecoder().decode(allObjects.self, from: data)
                } catch let error {
                    print(error)
                }
                    
                guard let json = decoded else {
                    return
                }
                for obj in json {
                    print("id:", obj.id)
                    print("name:", obj.name)
                    print("account_id:", obj.account_id)
                    print("uuid:", obj.uuid)
                    print("start_at:", obj.start_at)
                    print("grading_standard_id:", obj.grading_standard_id)
                    print("is_public:", obj.is_public)
                    print("created_at:", obj.created_at)
                    print("course_code:", obj.course_code)
                    print("default_view:", obj.default_view)
                    print("root_account_id:", obj.root_account_id)
                    print("enrollment_term_id:", obj.enrollment_term_id)
                    print("license:", obj.license)
                    print("grad_passback_setting:", obj.grad_passback_setting)
                    print("end_at:", obj.end_at)
                    print("public_syllabus:", obj.public_syllabus)
                    print("public_syllabus_to_auth:", obj.public_syllabus_to_auth)
                    print("storage_quota_mb:", obj.storage_quota_mb)
                    print("is_public_to_auth_users:", obj.is_public_to_auth_users)
                    print("homeroom_course:", obj.homeroom_course)
                    print("course_color:", obj.course_color)
                    print("friendly_name:", obj.friendly_name)
                    print("apply_assignment_group_weights:", obj.apply_assignment_group_weights)
                    print("calendar:", obj.calendar)
                    print("time_zone:", obj.time_zone)
                    print("blueprint:", obj.blueprint)
                    print("template:", obj.template)
                    print("enrollments:", obj.enrollments)
                    print("hide_final_grades:", obj.hide_final_grades)
                    print("workflow_state:", obj.workflow_state)
                    print("restrict_enrollments_to_course_dates:", obj.restrict_enrollments_to_course_dates)
                    print("overriden_course_visibility:", obj.overriden_course_visibility)
                    print()
                }
            }
        }
        task.resume()
    }
}


struct Object: Codable {
    let id: Int;
    let name: String;
    let account_id: Int;
    let uuid: String;
    let start_at: String?;
    let grading_standard_id: Int?;
    let is_public: Bool;
    let created_at: String;
    let course_code: String;
    let default_view: String;
    let root_account_id: Int;
    let enrollment_term_id: Int;
    let license: String;
    let grad_passback_setting: String?;
    let end_at: String?;
    let public_syllabus: Bool;
    let public_syllabus_to_auth: Bool;
    let storage_quota_mb: Int;
    let is_public_to_auth_users: Bool;
    let homeroom_course: Bool;
    let course_color: String?;
    let friendly_name: String?;
    let apply_assignment_group_weights: Bool;
    let calendar: Calendar;
    let time_zone: String;
    let blueprint: Bool;
    let template: Bool;
    let enrollments: [Enrollments];
    let hide_final_grades: Bool;
    let workflow_state: String;
    let restrict_enrollments_to_course_dates: Bool;
    let overriden_course_visibility: String?;
    
}

struct Calendar: Codable {
    let ics: String;
}

struct Enrollments: Codable {
    let type: String;
    let role: String;
    let role_id: Int;
    let user_id: Int;
    let enrollment_state: String;
    let limit_privileges_to_course_section: Bool;
}

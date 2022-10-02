//
//  My_AssignmentsApp.swift
//  My Assignments WatchKit Extension
//
//  Created by Ryan Madsen on 9/19/22.
//

import SwiftUI

@main
struct My_AssignmentsApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}

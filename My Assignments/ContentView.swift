//
//  ContentView.swift
//  My Assignments
//
//  Created by Ryan Madsen on 9/19/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var assignments = [String]()
    
    init() {
        print("Init")
    }
    
    func callAPI() {
        let enrollmentsURL: String = "https://canvas.instructure.com/api/v1/users/self/enrollments"
        let assignmentsURL: String = "https://canvas.instructure.com/api/v1/courses/"
        
        apiCaller.getEnrollments(strURL: enrollmentsURL, {
            apiCaller.getCourseName(strURL: assignmentsURL, ids: apiCaller.courseIDs, {
                print("done")
            })
            apiCaller.getAssignments(strURL: assignmentsURL, ids: apiCaller.courseIDs, {
                print("done")
                for obj in apiCaller.courseAssignments.values {
                    for str in obj {
                        print(str)
                        self.assignments.append(str)
                    }
                }
                print(self.assignments)
            })
        })
    }
    
//    let apiCaller = APICaller();
//
//    func callAPI() {
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
//                print("done")
//                group.leave()
//            })
//            group.enter()
//            apiCaller.getAssignments(strURL: assignmentsURL, ids: apiCaller.courseIDs, {
//                print("done")
//                for obj in apiCaller.courseAssignments.values {
//                    for str in obj {
//                        assignments.append(str)
//                    }
//                }
//                group.leave()
//            })
//            group.leave()
//        })
//
//        group.notify(queue: .main, execute: {})
//    }

    
    
    var body: some View {

        VStack() {
            HStack() {
                Image("Clipboard Symbol")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40.0, height: 40.0)
                Text("My Assignments")
                    .font(.largeTitle)
            }
            List {
                
                ForEach(assignments, id: \.self) { element in
                    HStack {
                        Text(element)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: .gray, radius: 3.0, x: 1.0, y: 1.0)
                        }
                }
                
                
                
                
                
//                HStack {
//                Text("Thing")
//                    .padding()
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                }
//                .background(Color.white)
//                .cornerRadius(10)
//                .shadow(color: .gray, radius: 3.0, x: 1.0, y: 1.0)
//                HStack {
//
//                Text("Thing")
//                    .padding()
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                }
//                .background(Color.white)
//                .cornerRadius(10)
//                .shadow(color: .gray, radius: 3.0, x: 1.0, y: 1.0)
//                HStack {
//
//                Text("Thing")
//                    .padding()
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                }
//                .background(Color.white)
//                .cornerRadius(10)
//                .shadow(color: .gray, radius: 3.0, x: 1.0, y: 1.0)
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            Spacer()
        }.onAppear{
            self.callAPI()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

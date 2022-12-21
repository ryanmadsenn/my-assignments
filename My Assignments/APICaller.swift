import Foundation
import UIKit

class APICaller {

    struct Enrollment: Codable {
        let course_id: Int;
    }

    struct Course: Codable {
        let name: String;
    }

    struct Assignment: Codable {
        let name: String;
    }

    var courseIDs = [Int]()
    var courseNames: [Int: String] = [:]
    var courseAssignments: [Int: [String]] = [:]
    var assignmentsArr = [String]()

    func getEnrollments(strURL: String, _ completion: @escaping () -> ()) {
        guard let url = URL(string: strURL) else{
            return
        }

        var request = URLRequest(url: url)
        request.setValue(APIkey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in

            if let data = data {
                var decoded: [Enrollment]?;
                typealias allObjects = [Enrollment]?;
                do {
                    decoded = try JSONDecoder().decode(allObjects.self, from: data)
                } catch let error {
                    print(error)
                }
                    
                guard let json = decoded else {
                    return
                }
                
                for obj in json {
                    self.courseIDs.append(obj.course_id)
                }
                
                completion()
            }
        }
        task.resume()
    }


    func getCourseName(strURL: String, ids: [Int], _ completion: @escaping () -> ()) {
        let group = DispatchGroup()
        for id in ids {
            guard let url = URL(string: strURL + String(id)) else{
                return
            }
            
            let APIkey = "Bearer 10706~eETfaVM6GyPNBUmx8CPHmdz1d8D8gVYfoKT7cNf3dv6NVeznzeKhX4t0DhmxXVnP"

            var request = URLRequest(url: url)
            request.setValue(APIkey, forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            group.enter()
            
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in

                if let data = data {
                    var decoded: Course?;
                    typealias allObjects = Course?;
                    do {
                        decoded = try JSONDecoder().decode(allObjects.self, from: data)
                    } catch let error {
                        print(error)
                    }
                        
                    guard let json = decoded else {
                        return
                    }
                
                    self.courseNames[id] = json.name
                }
                group.leave()
            }
            task.resume()
        }
        group.notify(queue: .main, execute: {completion()})
    }



    func getAssignments(strURL: String, ids: [Int], _ completion: @escaping () -> ()) {
        let group = DispatchGroup()
        for id in ids {
            guard let url = URL(string: strURL + String(id) + "/assignments") else{
                return
            }
            
            let APIkey = "Bearer 10706~eETfaVM6GyPNBUmx8CPHmdz1d8D8gVYfoKT7cNf3dv6NVeznzeKhX4t0DhmxXVnP"

            var request = URLRequest(url: url)
            request.setValue(APIkey, forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            group.enter()
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in

                if let data = data {
                    var decoded: [Assignment]?;
                    typealias allObjects = [Assignment]?;
                    do {
                        decoded = try JSONDecoder().decode(allObjects.self, from: data)
                    } catch let error {
                        print(error)
                    }
                        
                    guard let json = decoded else {
                        return
                    }
        //            for obj in json {
        //                print(obj.name)
        //            }
                    var assignments = [String]()
                    
                    for obj in json {
                        assignments.append(obj.name)
                    }
                    self.assignmentsArr.append(contentsOf: assignments)
                    self.courseAssignments[id] = assignments
                }
                group.leave()
            }
            task.resume()
        }
        group.notify(queue: .main, execute: {completion()})
    }

    
    func callAPI() {
        print(1)
    }
}

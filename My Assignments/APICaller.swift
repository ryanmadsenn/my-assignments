import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class APICaller {
    let enrollementsURL = "https://canvas.instructure.com/api/v1/users/self/enrollments"
    let baseURL = "https://canvas.instructure.com/api/v1/courses"
    let pageSuffix = "?page=1&per_page=100"
    let key = ProcessInfo.processInfo.environment["API_KEY"]

    func getCourseIDs(delay: Double, retries: Int, _ completion: @escaping ([CourseID]) -> ()) {
        let timer = Timer(timeInterval: delay, repeats: false) { timer in
            guard let url = URL(string: self.enrollementsURL + self.pageSuffix) else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.setValue(self.key, forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let response = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }
                
                // If response is ok.
                if response.statusCode == 200 {
                    guard let data = data else {
                        print("Invalid data")
                        return
                    }
                    
                    var decoded: [CourseID]?;
                    typealias allObjects = [CourseID]?;
                    
                    do {
                        decoded = try JSONDecoder().decode(allObjects.self, from: data)
                    } catch let error {
                        print()
                        print("❗️ Error decoding")
                        print("❗️ \(error)")
                        print("❗️ Error URL: \(url)")
                        print()
                    }
                    
                    guard let unwrapped = decoded else {
                        print()
                        print("❗️ Error unwrapping")
                        print("❗️ Error URL: \(url)")
                        print()
                        return
                    }
                    
                    completion(unwrapped)
                    
                // If response is rate-limited.
                } else if response.statusCode == 403 {
                    self.getCourseIDs(delay: delay + 0.5, retries: retries + 1, { unwrapped in
                        completion(unwrapped)
                    })
                }
            }
            task.resume()
        }
        RunLoop.main.add(timer, forMode: .common)
    }
    
    func getCourse(courseID: Int, delay: Double, retries: Int, _ completion: @escaping (Course) -> ()) {
        let timer = Timer(timeInterval: delay, repeats: false) { timer in
            guard let url = URL(string: "\(self.baseURL)/\(courseID)") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.setValue(self.key, forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let response = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }
                
                // If response is ok.
                if response.statusCode == 200 {
                    guard let data = data else {
                        print("Invalid data")
                        return
                    }
                    
                    var decoded: Course?;
                    typealias allObjects = Course?;
                    
                    do {
                        decoded = try JSONDecoder().decode(allObjects.self, from: data)
                    } catch let error {
                        print()
                        print("❗️ Error decoding")
                        print("❗️ \(error)")
                        print("❗️ Error URL: \(url)")
                        print()
                    }
                    
                    guard let unwrapped = decoded else {
                        print()
                        print("❗️ Error unwrapping")
                        print("❗️ Error URL: \(url)")
                        print()
                        return
                    }
                    
                    completion(unwrapped)
                    
                // If response is rate-limited.
                } else if response.statusCode == 403 {
                    self.getCourse(courseID: courseID, delay: delay + 0.5, retries: retries + 1, {course in
                        completion(course)
                    })
                }
            }
            task.resume()
        }
        RunLoop.main.add(timer, forMode: .common)
    }


    func getAllCourseAssignments(courseLoad: CourseLoad, _ completion: @escaping () -> ()) {
        let group = DispatchGroup()
        
        for i in 0...courseLoad.courses.count - 1 {
            if courseLoad.courses[i].name != nil {
                group.enter()
                getCourseAssignments(courseID: courseLoad.courses[i].id, delay: 0.0, retries: 0, { assignmentArr in
                    DispatchQueue.main.async {
                        courseLoad.courses[i].assignments = assignmentArr
                        group.leave()
                    }
                })
            } else {
                DispatchQueue.main.async {
                    courseLoad.courses[i].assignments = []
                }
            }
        }
        group.notify(queue: .main, execute: {completion()})
    }


    func getCourseAssignments(courseID: Int, delay: Double, retries: Int, _ completion: @escaping ([Assignment]) -> ()) {
        let timer = Timer(timeInterval: delay, repeats: false) { timer in
            guard let url = URL(string: "\(self.baseURL)/\(courseID)/assignments\(self.pageSuffix)") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.setValue(self.key, forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let response = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }
                
                // If response is ok.
                if response.statusCode == 200 {
                    guard let data = data else {
                        print("Invalid data")
                        return
                    }
                    
                    var decoded: [Assignment]?;
                    typealias allObjects = [Assignment]?;
                    
                    do {
                        decoded = try JSONDecoder().decode(allObjects.self, from: data)
                    } catch let error {
                        print()
                        print("❗️ Error decoding")
                        print("❗️ \(error)")
                        print("❗️ Error URL: \(url)")
                        print()
                    }
                    
                    guard let unwrapped = decoded else {
                        return
                    }
                    
                    completion(unwrapped)
                    
                // If response is rate-limited.
                } else if response.statusCode == 403 {
                    if retries < 4 {
                        self.getCourseAssignments(courseID: courseID, delay: delay + 0.5, retries: retries + 1, { assignmentArr in
                            completion(assignmentArr)
                        })
                    } else {
                        print("❗️Error: Unable to fetch data")
                        print("❗️Error URL: \(url)")
                        completion([])
                    }
                } else if let error = error {
                    print("❗️Error:")
                    print("❗️ \(error)")
                    completion([])
                }
            }
            task.resume()
        }
        RunLoop.main.add(timer, forMode: .common)
    }
}

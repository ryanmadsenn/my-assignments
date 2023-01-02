import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var sectionVisible = false
    @State var courseIDs = [CourseID]()
    @StateObject var courseLoad = CourseLoad()
    @StateObject var viewData = ViewData()
    @State var today = Date.now;
    
    func callAPI() {
        let apiCaller = APICaller()

        let semaphore = DispatchSemaphore(value: 0)

        let dispatchQueue = DispatchQueue.global(qos: .background)

        dispatchQueue.async{
            apiCaller.getCourseIDs(delay: 0.0, retries: 0, { courseIDs in
                DispatchQueue.main.async {
                    self.courseIDs = courseIDs
                    semaphore.signal()
                }
            })
            semaphore.wait()
            
            print(courseIDs)
            
            let group = DispatchGroup()
            
            for id in courseIDs {
                group.enter()
                
                print(id)
                apiCaller.getCourse(courseID: id.course_id, delay: 0.0, retries: 0, { course in
                    DispatchQueue.main.async {
                        courseLoad.courses.append(course)
                        group.leave()
                    }
                })
            }
            group.notify(queue: .main, execute: {semaphore.signal()})
            semaphore.wait()
            
            apiCaller.getAllCourseAssignments(courseLoad: courseLoad) {
                semaphore.signal()
            }
            semaphore.wait()
            
            DispatchQueue.main.async {
                
                let formatter = DateFormatter()
                
                formatter.dateFormat = "MMM d, yyyy"
                
                self.today = formatter.date(from: Date.now.formatted(date: .abbreviated, time: .omitted))!
                print(self.today)
                
                for i in 0..<courseLoad.courses.count {
                    for i2 in 0..<courseLoad.courses[i].assignments!.count {
                        if let due = courseLoad.courses[i].assignments![i2].due_at {
                            courseLoad.courses[i].assignments![i2].course = courseLoad.courses[i].name
                            
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                            
                            let date = formatter.date(from: due)
                            courseLoad.courses[i].assignments![i2].dueDate = date
                            
                            formatter.dateFormat = "MMM d, yyyy"
                            
                            let strAbbrDueDate = date?.formatted(date: .abbreviated, time: .omitted)
                            
                            let abbrDate = formatter.date(from: strAbbrDueDate!)
                            
                            courseLoad.courses[i].assignments![i2].abbrDueDate = abbrDate
                            
                            if viewData.datesAssignments[abbrDate!] != nil {
                                var arr = viewData.datesAssignments[abbrDate!]
                                arr?.append(courseLoad.courses[i].assignments![i2])
                                viewData.datesAssignments.updateValue(arr!, forKey: abbrDate!)
                            } else {
                                viewData.datesAssignments.updateValue([courseLoad.courses[i].assignments![i2]], forKey: abbrDate!)
                            }
                            
                            
                        } else {
                            print("❗️Failed: \(courseLoad.courses[i].assignments![i2].name)")
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        
        ZStack {
            Color("whitesmoke")
                .edgesIgnoringSafeArea(.all)

            NavigationView {
                if viewData.datesAssignments.count > 0 {
                    List {
                        TodaySectionView(colorMode: colorScheme, date: self.today, viewData: viewData)
                        
                        ForEach(Array(viewData.datesAssignments.keys.sorted(by: <)), id: \.self) { date in
                            if date >= self.today {
                                SectionView(colorMode: colorScheme, date: date, today: self.today, viewData: self.viewData)
                            }
                        }
                    }
                    .onAppear{
                        withAnimation(Animation.easeInOut(duration: 0.5), {
                            self.sectionVisible.toggle()
                        })
                        UITableView.appearance().backgroundColor = UIColor(Color("whitesmoke"))
                        UITableView.appearance().separatorColor = .gray
                        UITableView.appearance().separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
                    }
                    .listStyle(.insetGrouped)
                    .navigationTitle("My Assignments")
                    .opacity(sectionVisible ? 1 : 0)
                } else {
                    Text("Loading assignments...")
                        .navigationTitle("My Assignments")
                }
            }
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

struct AssignmentView: View {
    let colorMode: ColorScheme;
    let assign: Assignment
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(assign.name)
                Spacer()
                assign.has_submitted_submissions!
                ? Text("Submitted").font(.system(size: 13)).foregroundColor(.green)
                : Text("Not Submitted").font(.system(size: 13)).foregroundColor(.red)
            }
            HStack {
                Text(assign.course ?? "Unknown Course")
                    .font(.system(size: 15))
                .foregroundColor(.gray)
                Spacer()
                Text(assign.dueDate?.formatted(date: .omitted, time: .shortened) ?? "Unknown Time")
                    .font(.system(size: 12.5))
                    .foregroundColor(.gray)
                    .padding([.leading, .trailing], 2.5)
                    .background(Color("lightGray"))
                    .cornerRadius(2.5)
                    
            }
        }
    }
}

struct TodaySectionView: View {
    var colorMode: ColorScheme;
    var date: Date;
    var viewData: ViewData;
        
    var body: some View {
        Section(header: Text("Today").font(.system(size: 16)).bold()) {
            if viewData.datesAssignments.keys.contains(self.date) {
                ForEach(viewData.datesAssignments[date] ?? []) { assign in
                    AssignmentView(colorMode: colorMode, assign: assign)
                }
            } else {
                Text("No assignments due")
            }
        }
    }
}

struct SectionView: View {
    var colorMode: ColorScheme;
    var date: Date;
    var today: Date;
    var viewData: ViewData;
    
    var body: some View {
        Section(header: Text(date.formatted(date: .abbreviated, time: .omitted)).font(.system(size: 16)).bold()) {
            ForEach(viewData.datesAssignments[date] ?? []) { assign in
                AssignmentView(colorMode: colorMode, assign: assign)
            }
        }
    }
}

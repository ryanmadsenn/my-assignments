import Foundation

class CourseLoad : ObservableObject {
    init() {
        self.courses = []
    }
    
    @Published var courses: [Course];
}

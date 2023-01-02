import Foundation

class ViewData : ObservableObject {
    init() {}
    
    @Published var datesAssignments = [Date: [Assignment]]()
}

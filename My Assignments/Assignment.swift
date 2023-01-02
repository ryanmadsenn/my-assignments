import Foundation

struct Assignment : Codable, Identifiable {
    let id = UUID();
    let name: String;
    let due_at: String?;
    let has_submitted_submissions: Bool?;
    var course: String?;
    var dueDate: Date?;
    var abbrDueDate: Date?;
}

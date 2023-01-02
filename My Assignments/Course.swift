import Foundation

struct Course : Codable, Identifiable {
    let identifiableID = UUID();
    let name: String?;
    let id: Int;
    var assignments: [Assignment]?;
}

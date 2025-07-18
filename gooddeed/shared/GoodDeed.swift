import Foundation

struct GoodDeed: Identifiable, Equatable {
    let id: UUID
    var title: String
    var isCompleted: Bool
}

import Foundation

struct GoodDeed: Identifiable, Codable, Equatable {
    let id: UUID
    var text: String
    var isCompleted: Bool
    var isCustom: Bool

    init(id: UUID = UUID(), text: String, isCompleted: Bool = false, isCustom: Bool = false) {
        self.id = id
        self.text = text
        self.isCompleted = isCompleted
        self.isCustom = isCustom
    }

    enum CodingKeys: String, CodingKey {
        case id, text, isCompleted, isCustom
    }
}

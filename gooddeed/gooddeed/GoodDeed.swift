import Foundation

struct GoodDeed: Identifiable, Codable, Equatable {
    let id: UUID = UUID()
    let text: String
    var isCompleted: Bool = false
    var isCustom: Bool = false

    enum CodingKeys: String, CodingKey {
        case text, isCompleted, isCustom
        // id nije u ovom spisku jer se generiše automatski i ne dekodira se
    }
}


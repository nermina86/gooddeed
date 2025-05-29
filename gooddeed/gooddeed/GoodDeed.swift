//GoodDeed

import Foundation

struct GoodDeed: Identifiable, Codable, Equatable {
    let id = UUID()
    let text: String
    var isCompleted: Bool = false
    var isCustom: Bool = false
}

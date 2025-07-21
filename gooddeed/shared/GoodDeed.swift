// This file is part of the "GoodDeeds" application.
// © 2025 Nermina Memisevic. All rights reserved.
//
import Foundation

struct GoodDeed: Identifiable, Equatable {
    let id: UUID
    var title: String
    var isCompleted: Bool
}

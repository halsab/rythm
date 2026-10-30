//
//  Checklist.swift
//  Rythm
//
//  Created by Khalil Sabirov on 31.10.2026.
//

import Foundation
import SwiftData

@Model
final class Checklist {
    var title: String
    var symbolName: String = "checklist"
    var colorName: String = "blue"
    var isPinned: Bool = false
    var sortOrder: Int = 0
    
    var group: ListGroup?
    
    @Relationship(deleteRule: .cascade, inverse: \Step.checklist)
    var steps: [Step] = []
    
    init(title: String) {
        self.title = title
    }
}

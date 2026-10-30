//
//  ListGroup.swift
//  Rythm
//
//  Created by Khalil Sabirov on 31.10.2026.
//

import Foundation
import SwiftData

@Model
final class ListGroup {
    var title: String
    var symbolName: String = "folder.fill"
    var colorName: String = "blue"
    var sortOrder: Int = 0
    
    @Relationship(deleteRule: .nullify, inverse: \Checklist.group)
    var checklists: [Checklist] = []
    
    init(title: String) {
        self.title = title
    }
}

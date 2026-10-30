//
//  Step.swift
//  Rythm
//
//  Created by Khalil Sabirov on 31.10.2026.
//

import Foundation
import SwiftData

@Model
final class Step {
    var title: String
    var note: String = ""
    var durationSeconds: Int?
    var isCompleted: Bool = false
    var sortOrder: Int = 0
    
    var checklist: Checklist?
    
    init(title: String) {
        self.title = title
    }
}

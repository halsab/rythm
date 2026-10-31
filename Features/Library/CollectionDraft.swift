//
//  CollectionDraft.swift
//  Rythm
//
//  Created by Khalil Sabirov on 31.10.2026.
//

import Foundation

struct CollectionDraft {
    var title: String = ""
    var symbolName: String = CollectionSymbol.checklist.rawValue
    var colorName: String = CollectionColor.blue.rawValue
    
    var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isValid: Bool {
        !trimmedTitle.isEmpty
    }
}

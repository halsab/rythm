//
//  CollectionAppearance.swift
//  Rythm
//
//  Created by Khalil Sabirov on 31.10.2026.
//

import SwiftUI

enum CollectionColor: String, CaseIterable, Identifiable {
    case blue
    case orange
    case green
    case red
    case purple
    
    var id: String { rawValue }
    
    var title: LocalizedStringKey {
        switch self {
        case .blue: "Blue"
        case .orange: "Orange"
        case .green: "Green"
        case .red: "Red"
        case .purple: "Purple"
        }
    }
    
    var color: Color {
        switch self {
        case .blue: .blue
        case .orange: .orange
        case .green: .green
        case .red: .red
        case .purple: .purple
        }
    }
}

enum CollectionSymbol: String, CaseIterable, Identifiable {
    case checklist
    case folder = "folder.fill"
    case fitness = "dumbbell"
    case recipe = "fork.knife"
    case time = "clock"
    
    var id: String { rawValue }
    
    var title: LocalizedStringKey {
        switch self {
        case .checklist: "Checklist"
        case .folder: "Folder"
        case .fitness: "Fitness"
        case .recipe: "Recipe"
        case .time: "Time"
        }
    }
}

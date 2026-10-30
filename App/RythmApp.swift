//
//  RythmApp.swift
//  Rythm
//
//  Created by Khalil Sabirov on 30.10.2026.
//

import SwiftUI
import SwiftData

@main
struct RythmApp: App {
    var body: some Scene {
        WindowGroup {
            LibraryView()
        }
        .modelContainer(for: [
            ListGroup.self,
            Checklist.self,
            Step.self,
        ])
    }
}

//
//  ChecklistLink.swift
//  Rythm
//
//  Created by Khalil Sabirov on 01.11.2026.
//

import SwiftUI

struct ChecklistLink: View {
    let checklist: Checklist
    
    var body: some View {
        NavigationLink {
            ChecklistView(checklist: checklist)
        } label: {
            CollectionRow(
                title: checklist.title,
                symbolName: checklist.symbolName,
                colorName: checklist.colorName
            )
        }

    }
}

#Preview {
    ChecklistLink(checklist: .init(title: ""))
}

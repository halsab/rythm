//
//  GroupView.swift
//  Rythm
//
//  Created by Khalil Sabirov on 31.10.2026.
//

import SwiftUI
import SwiftData

struct GroupView: View {
    @Environment(\.modelContext) private var context
    
    let group: ListGroup
    
    @State private var showSaveError = false
    
    private var checklists: [Checklist] {
        group.checklists.sorted {
            $0.sortOrder < $1.sortOrder
        }
    }
    
    var body: some View {
        List {
            ForEach(checklists) { checklist in
                NavigationLink {
                    ChecklistView(checklist: checklist)
                } label: {
                    Label(
                        checklist.title,
                        systemImage: checklist.symbolName
                    )
                }

            }
        }
        .navigationTitle(group.title)
        .toolbar {
            Button("New list", systemImage: "plus") {
                addChecklist()
            }
        }
        .alert("Saving failed", isPresented: $showSaveError) {
            Button(role: .cancel) {}
        }
    }
    
    private func addChecklist() {
        let checklist = Checklist(
            title: "New list",
            group: group
        )
        
        checklist.sortOrder = (group.checklists.map(\.sortOrder).max() ?? -1) + 1
        
        do {
            try context.save()
        } catch {
            context.rollback()
            showSaveError = true
        }
    }
}

#Preview {
    GroupView(group: .init(title: ""))
}

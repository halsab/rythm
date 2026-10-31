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
    
    @State private var showingNewChecklist = false
    @State private var showingEditGroup = false
    
    private var checklists: [Checklist] {
        group.checklists
            .filter { !$0.isPinned }
            .sorted { $0.sortOrder < $1.sortOrder }
    }
    
    var body: some View {
        List {
            ForEach(checklists) { checklist in
                NavigationLink {
                    ChecklistView(checklist: checklist)
                } label: {
                    Label {
                        Text(checklist.title)
                    } icon: {
                        Image(systemName: checklist.symbolName)
                            .foregroundStyle(Color.app(checklist.colorName))
                    }
                }
            }
        }
        .navigationTitle(group.title)
        .toolbar {
            Button("Edit group", systemImage: "pencil") {
                showingEditGroup = true
            }
            
            Button("New list", systemImage: "plus") {
                showingNewChecklist = true
            }
        }
        .sheet(isPresented: $showingNewChecklist) {
            CollectionEditorView(
                heading: "New list"
            ) { title, symbol, color in
                let checklist = Checklist(title: title)
                checklist.symbolName = symbol
                checklist.colorName = color
                checklist.group = group
                checklist.sortOrder = (group.checklists.map(\.sortOrder).max() ?? -1) + 1
                
                context.insert(checklist)
                return save()
            }
        }
        .sheet(isPresented: $showingEditGroup) {
            CollectionEditorView(
                heading: "Edit group",
                title: group.title,
                symbolName: group.symbolName,
                colorName: group.colorName
            ) { title, symbol, color in
                group.title = title
                group.symbolName = symbol
                group.colorName = color
                
                return save()
            }
        }
    }
    
    private func save() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
}

#Preview {
    GroupView(group: .init(title: ""))
}

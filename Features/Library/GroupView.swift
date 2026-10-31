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
    
    @State private var editor: Editor?
    
    private enum Editor: String, Identifiable {
        case newChecklist
        case editGroup
        
        var id: String { rawValue }
    }
    
    private var actions: LibraryActions {
        LibraryActions(context: context)
    }
    
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
                    CollectionRow(
                        title: checklist.title,
                        symbolName: checklist.symbolName,
                        colorName: checklist.colorName
                    )
                }
            }
        }
        .navigationTitle(group.title)
        .toolbar {
            Button("Edit group", systemImage: "pencil") {
                editor = .editGroup
            }
            
            Button("New list", systemImage: "plus") {
                editor = .newChecklist
            }
        }
        .sheet(item: $editor) { selection in
            switch selection {
            case .newChecklist:
                CollectionEditorView(heading: "New list") { draft in
                    try actions.createChecklist(from: draft, in: group)
                }
                
            case .editGroup:
                CollectionEditorView(
                    heading: "Edit group",
                    draft: CollectionDraft(
                        title: group.title,
                        symbolName: group.symbolName,
                        colorName: group.colorName
                    )
                ) { draft in
                    try actions.updateGroup(group, with: draft)
                }
            }
        }
    }
}

#Preview {
    GroupView(group: .init(title: ""))
}

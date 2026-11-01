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
    
    @State private var editor: CollectionEditorRoute?
    
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
                ChecklistLink(checklist: checklist)
            }
        }
        .navigationTitle(group.title)
        .toolbar {
            Button("Edit group", systemImage: "pencil") {
                editor = .init(intent: .editGroup(group))
            }
            
            Button("New list", systemImage: "plus") {
                editor = .init(intent: .createChecklist(in: group))
            }
        }
        .collectionEditor($editor)
    }
}

#Preview {
    GroupView(group: .init(title: ""))
}

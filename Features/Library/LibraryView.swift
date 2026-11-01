//
//  LibraryView.swift
//  Rythm
//
//  Created by Khalil Sabirov on 31.10.2026.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.modelContext) private var context
    
    @Query(sort: \ListGroup.sortOrder)
    private var groups: [ListGroup]
    
    @Query(sort: \Checklist.sortOrder)
    private var checklists: [Checklist]
    
    @State private var editor: CollectionEditorRoute?
    
    private var actions: LibraryActions {
        LibraryActions(context: context)
    }
    
    private var pinned: [Checklist] {
        checklists.filter(\.isPinned)
    }
    
    private var ungrouped: [Checklist] {
        checklists.filter {
            $0.group == nil && !$0.isPinned
        }
    }
    
    @ViewBuilder
    private func checklistSection(
        _ title: LocalizedStringKey,
        items: [Checklist]
    ) -> some View {
        if !items.isEmpty {
            Section(title) {
                ForEach(items) { checklists in
                    ChecklistLink(checklist: checklists)
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if !groups.isEmpty {
                    Section("Groups") {
                        ForEach(groups) { group in
                            NavigationLink {
                                GroupView(group: group)
                            } label: {
                                CollectionRow(
                                    title: group.title,
                                    symbolName: group.symbolName,
                                    colorName: group.colorName
                                )
                            }
                        }
                    }
                }
                
                checklistSection("Pinned", items: pinned)
                checklistSection("Lists", items: ungrouped)
            }
            .navigationTitle("Rythm")
            .toolbar {
                Menu {
                    Button("New group", systemImage: "folder.badge.plus") {
                        editor = .init(intent: .createGroup)
                    }
                    
                    Button("New list", systemImage: "list.bullet") {
                        editor = .init(intent: .createChecklist(in: nil))
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
            .collectionEditor($editor)
        }
    }
}

#Preview {
    LibraryView()
}

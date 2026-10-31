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
    
    @State private var editor: Editor?
    
    private enum Editor: String, Identifiable {
        case newGroup
        case newChecklist
        
        var id: String { rawValue }
    }
    
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
    
    var body: some View {
        NavigationStack {
            List {
                if !pinned.isEmpty {
                    Section("Pinned") {
                        ForEach(pinned) { checklist in
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
                }
                
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
                
                if !ungrouped.isEmpty {
                    Section("Lists") {
                        ForEach(ungrouped) { checklist in
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
                }
            }
            .navigationTitle("Rythm")
            .toolbar {
                Menu {
                    Button("New group", systemImage: "folder.badge.plus") {
                        editor = .newGroup
                    }
                    
                    Button("New list", systemImage: "list.bullet") {
                        editor = .newChecklist
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(item: $editor) { selection in
                switch selection {
                case .newGroup:
                    CollectionEditorView(
                        heading: "New group",
                        draft: CollectionDraft(
                            symbolName: CollectionSymbol.folder.rawValue,
                        )
                    ) { draft in
                        try actions.createGroup(from: draft)
                    }
                    
                case .newChecklist:
                    CollectionEditorView(heading: "New list") { draft in
                        try actions.createChecklist(from: draft)
                    }
                }
            }
        }
    }
}

#Preview {
    LibraryView()
}

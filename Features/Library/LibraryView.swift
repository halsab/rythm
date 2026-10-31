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
    
    @State private var showingNewGroup = false
    @State private var showingNewChecklist = false
    
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
                        showingNewGroup = true
                    }
                    
                    Button("New list", systemImage: "list.bullet") {
                        showingNewChecklist = true
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingNewGroup) {
                CollectionEditorView(
                    heading: "New group",
                    symbolName: "folder.fill"
                ) { title, symbol, color in
                    let group = ListGroup(title: title)
                    group.symbolName = symbol
                    group.colorName = color
                    group.sortOrder = (groups.map(\.sortOrder).max() ?? -1) + 1
                    
                    context.insert(group)
                    return save()
                }
            }
            .sheet(isPresented: $showingNewChecklist) {
                CollectionEditorView(
                    heading: "New list"
                ) { title, symbol, color in
                    let checklist = Checklist(title: title)
                    checklist.symbolName = symbol
                    checklist.colorName = color
                    checklist.sortOrder = (checklists.map(\.sortOrder).max() ?? -1) + 1
                    
                    context.insert(checklist)
                    return save()
                }
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
    LibraryView()
}

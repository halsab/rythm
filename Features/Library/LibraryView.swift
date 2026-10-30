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
    
    @State private var showSaveError = false
    
    private var pinned: [Checklist] {
        checklists.filter(\.isPinned)
    }
    
    private var ungrouped: [Checklist] {
        checklists.filter { $0.group == nil }
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
                                Label(
                                    checklist.title,
                                    systemImage: checklist.symbolName
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
                                Label(
                                    group.title,
                                    systemImage: group.symbolName
                                )
                            }
                        }
                    }
                }
                
                if !ungrouped.isEmpty {
                    Section {
                        ForEach(ungrouped) { checklist in
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
                }
            }
            .navigationTitle("Rythm")
            .toolbar {
                Menu {
                    Button("New group", systemImage: "folder.badge.plus") {
                        context.insert(ListGroup(title: "New group"))
                        save()
                    }
                    
                    Button("New list", systemImage: "list.bullet") {
                        context.insert(Checklist(title: "New list"))
                        save()
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
            .alert("Saving failed", isPresented: $showSaveError) {
                Button(role: .cancel) {}
            }
        }
    }
    
    private func save() {
        do {
            try context.save()
        } catch {
            context.rollback()
            showSaveError = true
        }
    }
}

#Preview {
    LibraryView()
}

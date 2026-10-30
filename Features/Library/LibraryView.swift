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
    
    var body: some View {
        NavigationStack {
            List {
                Section("Pinned") {
                    ForEach(checklists.filter(\.isPinned)) { checklist in
                        Text(checklist.title)
                    }
                }
                
                Section("Groups") {
                    ForEach(groups) { group in
                        Label(group.title, systemImage: group.symbolName)
                    }
                }
                
                Section {
                    ForEach(checklists.filter { $0.group == nil }) { checklist in
                        Text(checklist.title)
                    }
                }
            }
            .navigationTitle("Rythm")
            .toolbar {
                Menu {
                    Button("New group", systemImage: "folder.badge.plus") {
                        context.insert(ListGroup(title: "New group"))
                    }
                    
                    Button("New list", systemImage: "list.bullet") {
                        context.insert(Checklist(title: "New list"))
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    LibraryView()
}

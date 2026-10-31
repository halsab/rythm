//
//  ChecklistView.swift
//  Rythm
//
//  Created by Khalil Sabirov on 31.10.2026.
//

import SwiftUI
import SwiftData

struct ChecklistView: View {
    @Environment(\.modelContext) private var context
    
    let checklist: Checklist
    
    @State private var showingEditChecklist = false
    @State private var showSaveError = false
    @State private var saveErrorMessage = ""
    
    private var actions: LibraryActions {
        LibraryActions(context: context)
    }
    
    private var steps: [Step] {
        checklist.steps.sorted {
            $0.sortOrder < $1.sortOrder
        }
    }
    
    private var completedCount: Int {
        checklist.steps.filter(\.isCompleted).count
    }
    
    var body: some View {
        List {
            Section {
                ForEach(steps) { step in
                    Label(
                        step.title,
                        systemImage: step.isCompleted
                        ? "checkmark.circle.fill"
                        : "circle"
                    )
                }
            } header: {
                Text("\(completedCount)/\(steps.count)")
            }
        }
        .navigationTitle(checklist.title)
        .toolbar {
            Button("Edit checklist", systemImage: "pencil") {
                showingEditChecklist = true
            }
            
            Button(
                checklist.isPinned ? "Unpin" : "Pin",
                systemImage: checklist.isPinned ? "pin.slash" : "pin"
            ) {
                do {
                    try actions.setPinned(
                        !checklist.isPinned,
                        for: checklist
                    )
                } catch {
                    saveErrorMessage = error.localizedDescription
                    showSaveError = true
                }
            }
        }
        .sheet(isPresented: $showingEditChecklist) {
            CollectionEditorView(
                heading: "Edit list",
                draft: CollectionDraft(
                    title: checklist.title,
                    symbolName: checklist.symbolName,
                    colorName: checklist.colorName
                )
            ) { draft in
                try actions.updateChecklist(checklist, with: draft)
            }
        }
        .alert("Saving failed", isPresented: $showSaveError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(saveErrorMessage)
        }
    }
}

#Preview {
    ChecklistView(checklist: .init(title: ""))
}

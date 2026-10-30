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
                checklist.isPinned.toggle()
                
                do {
                    try context.save()
                } catch {
                    context.rollback()
                    showSaveError = true
                }
            }
        }
        .sheet(isPresented: $showingEditChecklist) {
            CollectionEditorView(
                heading: "Edit list",
                title: checklist.title,
                symbolName: checklist.symbolName,
                colorName: checklist.colorName
            ) { title, symbol, color in
                checklist.title = title
                checklist.symbolName = symbol
                checklist.colorName = color
                
                do {
                    try context.save()
                    return true
                } catch {
                    context.rollback()
                    return false
                }
            }
        }
        .alert("Saving failed", isPresented: $showSaveError) {
            Button(role: .cancel) {}
        }
    }
}

#Preview {
    ChecklistView(checklist: .init(title: ""))
}

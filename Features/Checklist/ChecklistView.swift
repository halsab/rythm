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
    
    @State private var editor: CollectionEditorRoute?
    @State private var showSaveError = false
    @State private var saveErrorMessage = ""
    @State private var newStepTitle = ""
    @FocusState private var isAddingStepFocused: Bool
    @State private var editingStep: Step?
    @State private var editedTitle = ""
    @FocusState private var isEditingTitleFocused: Bool
    
    private var actions: LibraryActions {
        LibraryActions(context: context)
    }
    
    private var stepActions: ChecklistActions {
        ChecklistActions(context: context)
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
                    HStack(spacing: 12) {
                        Button {
                            toggleStep(step)
                        } label: {
                            Image(systemName: step.isCompleted
                                  ? "checkmark.circle.fill"
                                  : "circle"
                            )
                            .font(.title3)
                            .foregroundStyle(
                                step.isCompleted ? Color.accentColor : Color.secondary
                            )
                            .frame(minWidth: 44, minHeight: 44)
                        }
                        .buttonStyle(.borderless)
                        
                        if editingStep === step {
                            TextField("Step name", text: $editedTitle)
                                .focused($isEditingTitleFocused)
                                .submitLabel(.done)
                                .onSubmit(saveEditedStep)
                                .onAppear {
                                    isEditingTitleFocused = true
                                }
                            
                            Button("Cancel", systemImage: "xmark") {
                                cancelEditing()
                            }
                            .labelStyle(.iconOnly)
                            .buttonStyle(.borderless)
                        } else {
                            Button {
                                beginEditing(step)
                            } label: {
                                Text(step.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .contentShape(.rect)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                TextField("New step", text: $newStepTitle)
                    .focused($isAddingStepFocused)
                    .submitLabel(.next)
                    .onSubmit(addStep)
            } header: {
                Text("\(completedCount)/\(steps.count)")
            }
        }
        .onChange(of: isEditingTitleFocused) { wasFocused, isFocused in
            if wasFocused && !isFocused {
                saveEditedStep()
            }
        }
        .navigationTitle(checklist.title)
        .toolbar {
            Button("Edit list", systemImage: "pencil") {
                editor = .init(intent: .editChecklist(checklist))
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
        .collectionEditor($editor)
        .alert("Saving failed", isPresented: $showSaveError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(saveErrorMessage)
        }
    }
    
    private func addStep() {
        guard !newStepTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        do {
            try stepActions.addStep(
                named: newStepTitle,
                to: checklist
            )
            
            newStepTitle = ""
            isAddingStepFocused = true
        } catch {
            reportStepError(error)
        }
    }
    
    private func toggleStep(_ step: Step) {
        do {
            try stepActions.toggleCompletion(for: step)
        } catch {
            reportStepError(error)
        }
    }
    
    private func reportStepError(_ error: Error) {
        saveErrorMessage = error.localizedDescription
        showSaveError = true
    }
    
    private func beginEditing(_ step: Step) {
        if editingStep != nil {
            saveEditedStep()
            
            guard editingStep == nil else {
                return
            }
        }
        
        editedTitle = step.title
        editingStep = step
    }
    
    private func saveEditedStep() {
        guard let step = editingStep else {
            return
        }
        
        guard !editedTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            cancelEditing()
            return
        }
        
        do {
            try stepActions.renameStep(step, to: editedTitle)
            
            cancelEditing()
        } catch {
            reportStepError(error)
        }
    }
    
    private func cancelEditing() {
        editingStep = nil
        editedTitle = ""
        isEditingTitleFocused = false
    }
}

#Preview {
    ChecklistView(checklist: .init(title: ""))
}

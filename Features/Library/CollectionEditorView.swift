//
//  CollectionEditorView.swift
//  Rythm
//
//  Created by Khalil Sabirov on 31.10.2026.
//

import SwiftUI

struct CollectionEditorView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var draft: CollectionDraft
    @State private var showSaveError = false
    @State private var saveErrorMessage = ""
    
    let heading: String
    let onSave: @MainActor (CollectionDraft) throws -> Void
    
    init(
        heading: String,
        draft: CollectionDraft = .init(),
        onSave: @escaping @MainActor (CollectionDraft) throws -> Void
    ) {
        self.heading = heading
        self.onSave = onSave

        _draft = State(initialValue: draft)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $draft.title)
                }
                
                Section("Appearace") {
                    HStack {
                        Spacer()
                        
                        Image(systemName: draft.symbolName)
                            .font(.largeTitle)
                            .foregroundStyle(Color.app(draft.colorName))
                        
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    
                    Picker("Icon", selection: $draft.symbolName) {
                        ForEach(CollectionSymbol.allCases) { symbol in
                            Label(symbol.title, systemImage: symbol.rawValue)
                                .tag(symbol.rawValue)
                        }
                    }
                    
                    Picker("Color", selection: $draft.colorName) {
                        ForEach(CollectionSymbol.allCases) { option in
                            Text(option.title)
                                .tag(option.rawValue)
                        }
                    }
                }
            }
            .navigationTitle(heading)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        do {
                            try onSave(draft)
                            dismiss()
                        } catch {
                            saveErrorMessage = error.localizedDescription
                            showSaveError = true
                        }
                    }
                    .disabled(!draft.isValid)
                }
            }
            .alert("Saving failed", isPresented: $showSaveError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(saveErrorMessage)
            }
        }
    }
}

#Preview {
    CollectionEditorView(heading: "", onSave: { _ in })
}

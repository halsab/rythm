//
//  CollectionEditorView.swift
//  Rythm
//
//  Created by Khalil Sabirov on 31.10.2026.
//

import SwiftUI

struct CollectionEditorView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String
    @State private var symbolName: String
    @State private var colorName: String
    @State private var showSaveError = false
    
    let heading: String
    let onSave: (String, String, String) -> Bool
    
    init(
        heading: String,
        title: String = "",
        symbolName: String = "checklist",
        colorName: String = "blue",
        onSave: @escaping (String, String, String) -> Bool
    ) {
        self.heading = heading
        self.onSave = onSave

        _title = State(initialValue: title)
        _symbolName = State(initialValue: symbolName)
        _colorName = State(initialValue: colorName)
    }
    
    private var cleanTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $title)
                }
                
                Section("Appearace") {
                    HStack {
                        Spacer()
                        
                        Image(systemName: symbolName)
                            .font(.largeTitle)
                            .foregroundStyle(Color.app(colorName))
                        
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    
                    Picker("Icon", selection: $symbolName) {
                        Label("Checklist", systemImage: "checklist")
                            .tag("checklist")
                        Label("Folder", systemImage: "folder.fill")
                            .tag("folder.fill")
                        Label("Fitness", systemImage: "dumbbell")
                            .tag("dumbbell")
                        Label("Recipy", systemImage: "fork.knife")
                            .tag("fork.knife")
                        Label("Time", systemImage: "clock")
                            .tag("clock")
                    }
                    
                    Picker("Color", selection: $colorName) {
                        Text("Blue").tag("blue")
                        Text("Orange").tag("orange")
                        Text("Green").tag("green")
                        Text("Red").tag("red")
                        Text("Purple").tag("purple")
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
                        if onSave(cleanTitle, symbolName, colorName) {
                            dismiss()
                        } else {
                            showSaveError = true
                        }
                    }
                    .disabled(cleanTitle.isEmpty)
                }
            }
            .alert("Saving failed", isPresented: $showSaveError) {
                Button(role: .cancel) {}
            }
        }
    }
}

#Preview {
    CollectionEditorView(heading: "", onSave: { _,_,_ in true })
}

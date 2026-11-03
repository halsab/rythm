//
//  StepDetailsView.swift
//  Rythm
//
//  Created by Khalil Sabirov on 02.11.2026.
//

import SwiftUI

struct StepDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    
    let step: Step
    let onSave: @MainActor (String, Int?) throws -> Void
    
    @State private var note: String
    @State private var timerEnabled: Bool
    @State private var minutesText: String
    @State private var secondsText: String
    
    @State private var showSaveError = false
    @State private var saveErrorMessage = ""
    
    init(
        step: Step,
        onSave: @escaping @MainActor (String, Int?) throws -> Void
    ) {
        self.step = step
        self.onSave = onSave
        
        let duration = step.durationSeconds ?? 0
        
        _note = State(initialValue: step.note)
        _timerEnabled = State(
            initialValue: step.durationSeconds != nil
        )
        _minutesText = State(
            initialValue: String(duration / 60)
        )
        _secondsText = State(
            initialValue: String(duration % 60)
        )
    }
    
    private var selectedDuration: Int? {
        guard timerEnabled else {
            return nil
        }
        
        guard
            let minutes = Int(minutesText),
            let seconds = Int(secondsText),
            minutes >= 0,
            (0..<60).contains(seconds),
            minutes > 0 || seconds > 0,
            minutes <= (Int.max - seconds) / 60
                else {
            return nil
        }
        
        return minutes * 60 + seconds
    }
    
    private var isValid: Bool {
        !timerEnabled || selectedDuration != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Note") {
                    TextEditor(text: $note)
                        .frame(minHeight: 120)
                        .accessibilityLabel("Note")
                }
                
                Section("Timer") {
                    Toggle(
                        "Enable timer",
                        isOn: $timerEnabled
                    )
                    
                    if timerEnabled {
                        LabeledContent("Minutes") {
                            TextField(
                                "0",
                                text: $minutesText
                            )
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        }
                        
                        LabeledContent("Seconds") {
                            TextField(
                                "0",
                                text: $secondsText
                            )
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        }
                        
                        if selectedDuration == nil {
                            Text(
                                "Enter a positive duration. Seconds must be less than 60."
                            )
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Step details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .disabled(!isValid)
                }
            }
            .alert(
                "Saving failed",
                isPresented: $showSaveError
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(saveErrorMessage)
            }
        }
    }
    
    private func save() {
        do {
            try onSave(note, selectedDuration)
            dismiss()
        } catch {
            saveErrorMessage = error.localizedDescription
            showSaveError = true
        }
    }
}

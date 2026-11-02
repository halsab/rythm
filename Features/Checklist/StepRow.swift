//
//  StepRow.swift
//  Rythm
//
//  Created by Khalil Sabirov on 02.11.2026.
//

import SwiftUI

struct StepRow: View {
    let step: Step
    let isEditing: Bool

    @Binding var editedTitle: String
    @FocusState private var isTitleFocued: Bool

    let onToggleCompletion: () -> Void
    let onStartEditing: () -> Void
    let onCancelEditing: () -> Void
    let onSaveTitle: () -> Void
    let onShowDetails: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggleCompletion) {
                Image(
                    systemName: step.isCompleted
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

            if isEditing {
                TextField("Step name", text: $editedTitle)
                    .focused($isTitleFocued)
                    .submitLabel(.done)
                    .onSubmit(onSaveTitle)
                    .onAppear {
                        isTitleFocued = true
                    }
                    .onChange(of: isTitleFocued) { wasFocused, isFocused in
                        if wasFocused && !isFocused {
                            onSaveTitle()
                        }
                    }

                Button("Cancel", systemImage: "xmark") {
                    onCancelEditing()
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.borderless)
            } else {
                Button(action: onStartEditing) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(step.title)

                        if !step.note.isEmpty {
                            Text(step.note)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)

                Button(
                    "Step details",
                    systemImage: "ellipsis.circle",
                    action: onShowDetails
                )
            }
        }
    }
}

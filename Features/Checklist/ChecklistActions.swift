//
//  ChecklistActions.swift
//  Rythm
//
//  Created by Khalil Sabirov on 01.11.2026.
//

import Foundation
import SwiftData

@MainActor
struct ChecklistActions {
    let context: ModelContext
    
    enum ValidationError: LocalizedError {
        case emptyTitle
        case invalidDuration
        
        var errorDescription: String? {
            switch self {
            case .emptyTitle:
                "Name cannot be empty."
            case .invalidDuration:
                "Duration must be greater than zero."
            }
        }
    }
    
    // MARK: - Create
    
    func addStep(
        named rawTitle: String,
        to checklist: Checklist
    ) throws {
        let title = rawTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !title.isEmpty else {
            throw ValidationError.emptyTitle
        }
        
        let nextOrder = (checklist.steps.map(\.sortOrder).max() ?? -1) + 1
        
        let step = Step(title: title)
        step.sortOrder = nextOrder
        
        context.insert(step)
        checklist.steps.append(step)
        
        do {
            try context.save()
        } catch {
            checklist.steps.removeAll { $0 === step }
            context.delete(step)
            throw error
        }
    }
    
    // MARK: - Completion
    
    func toggleCompletion(for step: Step) throws {
        let previousValue = step.isCompleted
        step.isCompleted.toggle()
        
        do {
            try context.save()
        } catch {
            step.isCompleted = previousValue
            throw error
        }
    }
    
    // MARK: - Rename
    
    func renameStep(
        _ step: Step,
        to rawTitle: String
    ) throws {
        let title = rawTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !title.isEmpty else {
            throw ValidationError.emptyTitle
        }
        
        guard step.title != title else {
            return
        }
        
        let previousTitle = step.title
        step.title = title
        
        do {
            try context.save()
        } catch {
            step.title = previousTitle
            throw error
        }
    }
    
    // MARK: - Details
    
    func updateDetails(
        for step: Step,
        note: String,
        durationSeconds: Int?
    ) throws {
        if let durationSeconds, durationSeconds <= 0 {
            throw ValidationError.invalidDuration
        }
        
        guard step.note != note || step.durationSeconds != durationSeconds else {
            return
        }
        
        let previousNote = step.note
        let previousDuration = step.durationSeconds
        
        step.note = note
        step.durationSeconds = durationSeconds
        
        do {
            try context.save()
        } catch {
            step.note = previousNote
            step.durationSeconds = previousDuration
            throw error
        }
    }
}

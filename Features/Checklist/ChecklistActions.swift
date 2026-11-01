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
        
        var errorDescription: String? {
            switch self {
            case .emptyTitle:
                "Name cannot be empty."
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
}

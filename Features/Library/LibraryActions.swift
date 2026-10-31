//
//  LibraryActions.swift
//  Rythm
//
//  Created by Khalil Sabirov on 31.10.2026.
//

import Foundation
import SwiftData

@MainActor
struct LibraryActions {
    let context: ModelContext
    
    enum ValidatorError: LocalizedError {
        case emptyTitle
        
        var errorDescription: String? {
            switch self {
            case .emptyTitle:
                "Name cannot be empty."
            }
        }
    }
    
    // MARK: - Create
    
    func createGroup(from draft: CollectionDraft) throws {
        let title = try validatedTitle(from: draft)
        let groups = try context.fetch(FetchDescriptor<ListGroup>())
        
        let group = ListGroup(title: title)
        group.symbolName = draft.symbolName
        group.colorName = draft.colorName
        group.sortOrder = (groups.map(\.sortOrder).max() ?? -1) + 1
        
        context.insert(group)
        try persist()
    }
    
    func createChecklist(
        from draft: CollectionDraft,
        in group: ListGroup? = nil
    ) throws {
        let title = try validatedTitle(from: draft)
        
        let all = try context.fetch(FetchDescriptor<Checklist>())
        
        let siblings = all.filter {
            $0.group?.persistentModelID == group?.persistentModelID
        }
        
        let checklist = Checklist(title: title, group: group)
        checklist.symbolName = draft.symbolName
        checklist.colorName = draft.colorName
        checklist.sortOrder = (siblings.map(\.sortOrder).max() ?? -1) + 1
        
        context.insert(checklist)
        try persist()
    }
    
    // MARK: - Update
    
    func updateGroup(
        _ group: ListGroup,
        with draft: CollectionDraft
    ) throws {
        group.title = try validatedTitle(from: draft)
        group.symbolName = draft.symbolName
        group.colorName = draft.colorName
        
        try persist()
    }
    
    func updateChecklist(
        _ checklist: Checklist,
        with draft: CollectionDraft
    ) throws {
        checklist.title = try validatedTitle(from: draft)
        checklist.symbolName = draft.symbolName
        checklist.colorName = draft.colorName
        
        try persist()
    }
    
    // MARK: - Pinning
    
    func setPinned(
        _ isPinned: Bool,
        for checklist: Checklist
    ) throws {
        checklist.isPinned = isPinned
        
        try persist()
    }
    
    // MARK: - Helpers
    
    private func validatedTitle(from draft: CollectionDraft) throws -> String {
        let title = draft.trimmedTitle
        
        guard !title.isEmpty else {
            throw ValidatorError.emptyTitle
        }
        
        return title
    }
    
    private func persist() throws {
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            context.rollback()
            throw error
        }
    }
}

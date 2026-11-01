//
//  CollectionEditorSheet.swift
//  Rythm
//
//  Created by Khalil Sabirov on 01.11.2026.
//

import SwiftUI
import SwiftData

enum CollectionText {
    static let newGroup: LocalizedStringKey = "New group"
    static let newList: LocalizedStringKey = "New list"
    static let editGroup: LocalizedStringKey = "Edit group"
    static let editList: LocalizedStringKey = "Edit list"
}

struct CollectionEditorRoute: Identifiable {
    enum Intent {
        case createGroup
        case createChecklist(in: ListGroup?)
        case editGroup(ListGroup)
        case editChecklist(Checklist)
    }
    
    let id = UUID()
    let intent: Intent
    
    var title: LocalizedStringKey {
        switch intent {
        case .createGroup: CollectionText.newGroup
        case .createChecklist: CollectionText.newList
        case .editGroup: CollectionText.editGroup
        case .editChecklist: CollectionText.editList
        }
    }
    
    var draft: CollectionDraft {
        switch intent {
        case .createGroup:
            CollectionDraft(
                symbolName: CollectionSymbol.folder.rawValue
            )
            
        case .createChecklist:
            CollectionDraft()
            
        case .editGroup(let group):
            CollectionDraft(
                title: group.title,
                symbolName: group.symbolName,
                colorName: group.colorName
            )
            
        case .editChecklist(let checklist):
            CollectionDraft(
                title: checklist.title,
                symbolName: checklist.symbolName,
                colorName: checklist.colorName
            )
        }
    }
    
    @MainActor
    func save(
        _ draft: CollectionDraft,
        using actions: LibraryActions
    ) throws {
        switch intent {
        case .createGroup:
            try actions.createGroup(from: draft)
            
        case .createChecklist(let group):
            try actions.createChecklist(from: draft, in: group)
            
        case .editGroup(let group):
            try actions.updateGroup(group, with: draft)
            
        case .editChecklist(let checklist):
            try actions.updateChecklist(checklist, with: draft)
        }
    }
}


private struct CollectionEditorPresenter: ViewModifier {
    @Environment(\.modelContext) private var context
    @Binding var route: CollectionEditorRoute?
    
    func body(content: Content) -> some View {
        content
            .sheet(item: $route) { request in
                CollectionEditorView(
                    heading: request.title,
                    draft: request.draft) { draft in
                        let actions = LibraryActions(context: context)
                        try request.save(draft, using: actions)
                    }
            }
    }
}

extension View {
    func collectionEditor(
        _ route: Binding<CollectionEditorRoute?>
    ) -> some View {
        modifier(CollectionEditorPresenter(route: route))
    }
}

//
//  CollectionRow.swift
//  Rythm
//
//  Created by Khalil Sabirov on 31.10.2026.
//

import SwiftUI

struct CollectionRow: View {
    let title: String
    let symbolName: String
    let colorName: String
    
    var body: some View {
        Label {
            Text(title)
        } icon: {
            Image(systemName: symbolName)
                .foregroundStyle(Color.app(colorName))
        }
    }
}

#Preview {
    CollectionRow(title: "", symbolName: "", colorName: "")
}

//
//  AppColor.swift
//  Rythm
//
//  Created by Khalil Sabirov on 31.10.2026.
//

import SwiftUI

extension Color {
    static func app(_ name: String) -> Color {
        switch name {
        case "orange": .orange
        case "green": .green
        case "red": .red
        case "purple": .purple
        default: .blue
        }
    }
}

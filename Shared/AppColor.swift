//
//  AppColor.swift
//  Rythm
//
//  Created by Khalil Sabirov on 31.10.2026.
//

import SwiftUI

extension Color {
    static func app(_ name: String) -> Color {
        CollectionColor(rawValue: name)?.color ?? .blue
    }
}

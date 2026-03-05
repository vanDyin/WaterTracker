//
//  DrinkColor.swift
//  WaterTracker
//
//  Created by Вячеслав Полянский on 06.02.2026.
//

import SwiftUI

enum DrinkColor: Codable {
    case lightBlue
    case coffee
    case peach
}

extension DrinkColor {
    var color: Color {
        switch self {
        case .lightBlue:
            return Color(red: 189/255, green: 224/255, blue: 254/255)
        case .coffee:
            return Color(red: 212/255, green: 163/255, blue: 115/255)
        case .peach:
            return Color(red: 250/255, green: 229/255, blue: 136/255)
        }
    }
}

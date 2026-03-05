//
//  VolumeOption.swift
//  WaterTracker
//
//  Created by Вячеслав Полянский on 15.01.2026.
//

import Foundation

// For drink presets
struct VolumeOption: Identifiable, Codable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let iconName: String
    let color: DrinkColor
    
    private enum CodingKeys: CodingKey {
        case name, iconName, color
    }
}

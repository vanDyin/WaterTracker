//
//  DrinkEntry.swift
//  WaterTracker
//
//  Created by Вячеслав Полянский on 05.02.2026.
//

import Foundation

struct DrinkEntry: Identifiable, Codable, Equatable, Hashable {
    let id = UUID()
    var option: VolumeOption
    var amount: Int
    
    // for remove the warning about UUID
    private enum CodingKeys: CodingKey {
        case option, amount
    }
}

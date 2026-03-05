//
//  DrinkEntry.swift
//  WaterTracker
//
//  Created by Вячеслав Полянский on 05.02.2026.
//

import Foundation

struct DrinkEntry: Identifiable, Hashable, Equatable {
    let id = UUID()
    var option: VolumeOption
    var totalAmount: Double
}

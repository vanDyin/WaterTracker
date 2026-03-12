//
//  DailyIntake.swift
//  WaterTracker
//
//  Created by Вячеслав Полянский on 15.01.2026.
//

import Foundation

struct DailyIntake: Codable, Identifiable {
    let id = UUID()
    let date: Date
    var goal: Int
    var drinks: [DrinkEntry] = []
    
    var amount: Int {
        drinks.reduce(0) { $0 + $1.totalAmount }
    }
    
    var progress: Double {
        goal > 0 ? Double(amount) / Double(goal) : 0
    }
    
    var percentage: Int {
        Int(progress * 100)
    }
    
    // for remove the warning about UUID
    private enum CodingKeys: CodingKey {
        case date, goal, drinks
    }
}

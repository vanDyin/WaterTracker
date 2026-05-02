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
        drinks.reduce(0) { $0 + $1.amount }
    }
    
    var progress: Double {
        goal > 0 ? Double(amount) / Double(goal) : 0
    }
    
    var percentage: Int {
        Int(progress * 100)
    }
    
    var chronologicalEntries: [DrinkEntry] {
        guard !drinks.isEmpty else { return [] }
        
        var entries: [DrinkEntry] = []
        var currentDrink = drinks.first!
        
        for nextDrink in drinks.dropFirst() {
            
            if nextDrink.option == currentDrink.option {
                currentDrink.amount += nextDrink.amount
            } else {
                entries.append(currentDrink)
                currentDrink = nextDrink
            }
        }
        entries.append(currentDrink)
        return entries
    }
    
    var aggregatedEntries: [DrinkEntry] {
        var dict: [VolumeOption : Int] = [:]
        var order: [VolumeOption] = []
        
        for drink in drinks {
            if dict[drink.option] == nil {
                order.append(drink.option)
            }
            dict[drink.option, default: 0] += drink.amount
        }
        
        return order.map { DrinkEntry(option: $0, amount: dict[$0]!) }
    }
    
    // for remove the warning about UUID
    private enum CodingKeys: CodingKey {
        case date, goal, drinks
    }
}

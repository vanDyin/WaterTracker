//
//  WaterTrackerViewModel.swift
//  WaterTracker
//
//  Created by Вячеслав Полянский on 15.01.2026.
//

import SwiftUI
import Observation

@Observable
final class WaterTrackerViewModel {
    var currentIntake: DailyIntake
    var entries: [DrinkEntry] = []
    var history: [DailyIntake] = [] {
        didSet {
            saveHistory()
        }
    }
    
    var goal: Double {
        didSet {
            UserDefaults.standard.set(goal, forKey: "dailyGoal")
            currentIntake.goal = goal
        }
    }
    
    var currentAmount: Double {
        entries.reduce(0.0) { $0 + $1.totalAmount }
    }
    
    var visualTotal: Double {
        max(currentAmount, goal)
    }
    
    init() {
        let initialGoal = Self.loadGoal()
        goal = initialGoal
        
        if let loadedHistory = Self.loadHistory() {
            history = loadedHistory
        }
        
        let today = Calendar.current.startOfDay(for: Date())
        currentIntake = DailyIntake(date: today, amount: 0, goal: initialGoal)
    }
    
    private static func loadGoal() -> Double {
        let savedGoal = UserDefaults.standard.double(forKey: "dailyGoal")
        
        if savedGoal > 0 {
            return savedGoal
        }
        
        return calculateGoal()
    }
    
    private static func calculateGoal() -> Double {
        // Сделать функцию, которая считает цель по параметрам
        //FIXME: calculation goal
        return 2200
    }
    
    private static func loadHistory() -> [DailyIntake]? {
        let defaults = UserDefaults.standard
        if let savedData = defaults.data(forKey: "history") {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode([DailyIntake].self, from: savedData) {
                return loadedData
            }
        }
        return nil
    }
    
    
    func saveHistory() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(history) {
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: "history")
        }
    }
    
    func addDrink(option: VolumeOption, amount: Double) {
        startNewDayIfNeeded()
        if let index = entries.firstIndex(where: { $0.option.id == option.id }) {
            entries[index].totalAmount += amount
        } else {
            entries.append(DrinkEntry(option: option, totalAmount: amount))
        }
    }
    
    func startNewDayIfNeeded() {
        let todayStart = Calendar.current.startOfDay(for: Date())
        
        if currentIntake.date != todayStart {
            currentIntake.amount = currentAmount
            history.append(currentIntake)
            currentIntake = DailyIntake(date: todayStart, amount: 0, goal: currentIntake.goal)
            entries.removeAll()
        }
    }
    
    func intake(for date: Date) -> DailyIntake? {
        let calendar = Calendar.current
        
        if calendar.isDate(Date(), inSameDayAs: date) {
            return currentIntake
        } else {
            return history.first {
                calendar.isDate($0.date, inSameDayAs: date)
            }
        }
    }
    
    func didReachGoal(on date: Date) -> Bool {
        guard let intake = intake(for: date) else { return false }
        return intake.amount >= intake.goal
    }
    
    // In quick access
    // Need to add 'isFavorite' in 'VolumeOption' to make it automatic
    var availableOptions: [VolumeOption] = [
        .init(name: "Coffee", iconName: "cup.and.heat.waves", color: .coffee),
        .init(name: "Water", iconName: "cup.and.saucer", color: .lightBlue),
        .init(name: "Juice", iconName: "mug", color: .peach)
    ]
    
    // Drink presets
    var presetOptions: [VolumeOption] = [
        .init(name: "Coffee", iconName: "cup.and.heat.waves", color: .coffee),
        .init(name: "Glass", iconName: "cup.and.saucer", color: .lightBlue),
        .init(name: "Juice", iconName: "mug", color: .peach)
    ]
    
}

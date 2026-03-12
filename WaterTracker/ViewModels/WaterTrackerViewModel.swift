//
//  WaterTrackerViewModel.swift
//  WaterTracker
//
//  Created by Вячеслав Полянский on 15.01.2026.
//

import SwiftUI
import Observation

// Мне не нравится что теперь todayIntake нужно unwrapp'ать каждый раз
// Исправить ошибки в других файлах, так как залупа полная

@Observable
final class WaterTrackerViewModel {
    private let key = "hydration_history"
    
    var history: [DailyIntake] = [] {
        didSet {
            save()
        }
    }
    
    private var todayIndex: Int {
        history.firstIndex {
            Calendar.current.isDateInToday($0.date)
        }!
    }

    var todayIntake: DailyIntake {
        history[todayIndex]
    }
    
    var visualTotal: Int {
        return max(todayIntake.amount, todayIntake.goal)
    }
    
    init() {
        load()
        startNewDayIfNeeded()
    }
    
    private func load() {
        let defaults = UserDefaults.standard
        
        guard
            let data = defaults.data(forKey: key),
            let decodedData = try? JSONDecoder().decode([DailyIntake].self, from: data)
        else { return }
        
        history = decodedData
    }
    
    
    private func save() {
        guard let data = try? JSONEncoder().encode(history) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func addDrink(_ entry: DrinkEntry) {
        startNewDayIfNeeded()
        
        guard let index = history.firstIndex(where: {
            Calendar.current.isDateInToday($0.date)
        }) else { return }
        
        history[index].drinks.append(entry)
    }
    
    func startNewDayIfNeeded() {

        if !history.contains(where: {
            Calendar.current.isDateInToday($0.date)
        }) {
            let newDay = DailyIntake(
                date: Date(),
                goal: 2000
            )

            history.insert(newDay, at: 0)
        }
    }
    
    func intake(for date: Date) -> DailyIntake? {
        history.first {
            Calendar.current.isDate($0.date, inSameDayAs: date)
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

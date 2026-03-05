//
//  WaterTrackerApp.swift
//  WaterTracker
//
//  Created by Вячеслав Полянский on 12.01.2026.
//

import SwiftUI

@main
struct WaterTrackerApp: App {
    @State private var viewModel = WaterTrackerViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView()
            }
            .environment(viewModel)
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                viewModel.startNewDayIfNeeded()
            }
        }
    }
}

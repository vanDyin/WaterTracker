//
//  DrinkHistoryView.swift
//  WaterTracker
//
//  Created by Вячеслав Полянский on 07.03.2026.
//

import SwiftUI

struct DrinkHistoryView: View {
    let drinks: [DrinkEntry]
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    @Previewable @State var viewModel = WaterTrackerViewModel()
    DrinkHistoryView(drinks: viewModel.todayIntake.drinks)
}

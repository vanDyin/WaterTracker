//
//  ContentView.swift
//  WaterTracker
//
//  Created by Вячеслав Полянский on 12.01.2026.
//

import SwiftUI

struct MainView: View {

    @Environment(WaterTrackerViewModel.self) private var viewModel
    @State private var route: MainRoute?
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)
                VStack {
                    ZStack {
                        ProgressRingView(visualTotal: viewModel.visualTotal, entries: viewModel.todayIntake.drinks)
                        
                        VStack {
                            Text("\(viewModel.todayIntake.amount/viewModel.todayIntake.goal * 100, specifier: "%.0f")%")
                                .font(.largeTitle)
                            
                            Text("\(Int(viewModel.todayIntake.amount)) / \(Int(viewModel.todayIntake.goal)) ml")
                                .font(.title)
                        }
                    }
                    .frame(width: size * 0.75, height: size * 0.75)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .safeAreaPadding(.top)
            }
            .frame(maxHeight: .infinity)
            
            HStack {
                ForEach(viewModel.availableOptions) { option in
                    Button {
                        viewModel.addDrink(
                            DrinkEntry(option: option, totalAmount: 300)//FIXME: amount
                        )
                    } label: {
                        Label(option.name, systemImage: option.iconName)
                            .font(.callout)
                            .foregroundStyle(.white)
                            .padding()
                            .background(option.color.color)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    route = .calendar
                } label: {
                    Image(systemName: "calendar")
                        .foregroundStyle(.black)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    route = .settings
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .navigationDestination(item: $route) { route in
            switch route {
            case .calendar:
                CalendarView()
            case .settings:
                SettingsView()
            }
        }
    }
}

enum MainRoute: Hashable {
    case calendar
    case settings
}


#Preview {
    NavigationStack {
        MainView()
    }
    .environment(WaterTrackerViewModel())
}

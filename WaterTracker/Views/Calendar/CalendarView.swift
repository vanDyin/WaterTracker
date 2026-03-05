//
//  CalendarView.swift
//  WaterTracker
//
//  Created by Вячеслав Полянский on 20.02.2026.
//

import SwiftUI
import Foundation

struct CalendarView: View {
    @Environment(WaterTrackerViewModel.self) private var viewModel
    @State private var displayedDate = Date()
    
    var weekdays: [String] {
        let symbols = Calendar.current.veryShortStandaloneWeekdaySymbols
        return Array(symbols[1...6] + [symbols[0]])
    }
    
    var days: [Date] {
        displayedDays(from: displayedDate)
    }

    var dayOffset: Int {
        offsetForDays(for: displayedDate)
    }
    
    var month: String {
        displayedMonth(from: displayedDate)
    }
    
    var isCurrentMonth: Bool {
        Calendar.current.isDate(displayedDate, equalTo: Date(), toGranularity: .month)
    }
    
    func firstDayOfMonth(from date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func displayedMonth(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.setLocalizedDateFormatFromTemplate("MMMM")
        return formatter.string(from: date)
    }
    
    func displayedDays(from date: Date) -> [Date] {
        let calendar = Calendar.current
        
        // beginning of month
        let firstDay = firstDayOfMonth(from: date)
        
        // Number of days in the month
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numberOfDays = range.count

        //return
        return (0..<numberOfDays).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: firstDay)
        }
    }
    
    func offsetForDays(for date: Date) -> Int {
        let calendar = Calendar.current
        
        let firstDay = firstDayOfMonth(from: date)
        let weekday = calendar.component(.weekday, from: firstDay)
        
        let offset = (weekday + 5) % 7
        
        return offset
    }
    
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        
        if value > 0 && isCurrentMonth {
            return
        }
        if let newDate = calendar.date(byAdding: .month, value: value, to: displayedDate) {
            displayedDate = newDate
        }
    }
    
    var body: some View {
        VStack {
            HStack{
                Button {
                    changeMonth(by: -1)
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 36, height: 36)
                }
                .background(
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                )
                
                Text(month)
                    .fontWeight(.black)
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity)
                
                Button {
                    changeMonth(by: 1)
                } label: {
                    Image(systemName: "chevron.forward")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 36, height: 36)
                }
                .background(
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                )
                .disabled(isCurrentMonth)
            }


            HStack {
                ForEach(weekdays.indices, id: \.self) { index in
                    Text(weekdays[index])
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(0..<dayOffset, id: \.self) { _ in
                    Text("")
                }
                
                ForEach(days, id: \.self) { day in
                    let isToday = Calendar.current.isDateInToday(day)
                    
                    Text(day.formatted(.dateTime.day()))
                        .fontWeight(.bold)
                        .foregroundStyle(isToday ? .white : .secondary)
                        .frame(maxWidth: .infinity, minHeight: 35)
                        .background(
                            Circle()
                                .fill(isToday ? Color.blue : Color.clear)

                        )
                        .overlay (
                            Circle()
                                .stroke(viewModel.didReachGoal(on: day) ? .blue : .clear, lineWidth: 2)
                        )
                }
            }
        }
        .padding()
    }
}


#Preview {
    CalendarView()
        .environment(WaterTrackerViewModel())
}

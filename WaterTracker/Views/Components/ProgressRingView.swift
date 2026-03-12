//
//  ProgressRingView.swift
//  WaterTracker
//
//  Created by Вячеслав Полянский on 25.01.2026.
//

import SwiftUI

//FIXME: broken progress 

struct ProgressRingView: View {
    let visualTotal: Int
    var entries: [DrinkEntry]
    
    let lineWidth: Double = 40
    let space: Double = 0.01 / 2
    
    private func gap(for radius: Double) -> Double {
        let circumference = 2 * .pi * radius
        return ((lineWidth / 2) / circumference)
    }
    
    private var segments: [(entry: DrinkEntry, start: Double, end: Double)] {
        var result: [(DrinkEntry, Double, Double)] = []
        var current: Double = 0
        
        for entry in entries {
            let fragment = Double(entry.totalAmount) / Double(visualTotal)
            let start = current
            let end = min(current + fragment, 1.0)
            
            result.append((entry, start, end))
            current = end
        }
        return result
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                let radius = min(geo.size.width, geo.size.height) / 2
                let gap = gap(for: radius)
                
                Circle()
                    .stroke(.gray.opacity(0.05), lineWidth: lineWidth)
                
                ForEach(segments, id: \.entry.id) { segment in
                    let start = segment.start + gap + space
                    let end = segment.end - gap - space
                    
                    let angle = Angle(degrees: start * 360 - 90)
                    
                    let x = geo.size.width / 2 + cos(angle.radians) * radius
                    let y = geo.size.height / 2 + sin(angle.radians) * radius
                    
                    Circle()
                        .trim(from: start, to: end)
                        .stroke(
                            segment.entry.option.color.color,
                            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                    
                    Image(systemName: segment.entry.option.iconName)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(width: 20, height: 20)
                        .position(x: x, y: y)
                }
            }
        }
    }
}

#Preview {
    ProgressRingView(visualTotal: 2200, entries: [
        .init(option: VolumeOption(name: "Coffee", iconName: "cup.and.heat.waves", color: .coffee), totalAmount: 250),
        .init(option: VolumeOption(name: "Glass", iconName: "cup.and.saucer", color: .lightBlue), totalAmount: 330),
        .init(option: VolumeOption(name: "Juice", iconName: "mug", color: .peach), totalAmount: 300)
    ])
        .padding(50)
}

//
//  ProgressRingView.swift
//  WaterTracker
//
import SwiftUI
import Charts

struct ChartsProgressView: View {
    // MARK: - Properties
    let entries: [DrinkEntry]
    
    // MARK: - Constants
    private enum DesignConstants {
        // Ring geometry
        static let innerRadiusRatio: CGFloat = 0.76
        static let outerRadiusRatio: CGFloat = 1.0
        static let angularInset: CGFloat = 5
        
        // Icon
        static let iconSizeRatio: CGFloat = 0.07
        
        // Position calculation
        static let startAngle: Double = -90 // Start from top (12 o'clock)
        static let degreesInCircle: Double = 360
        static let degreesInHalfCircle: Double = 180
        static let radiansToDegrees: Double = .pi / 180
    }
    
    private enum Calculation {
        static func midRadiusRatio(inner: CGFloat, outer: CGFloat) -> CGFloat {
            (inner + outer) / 2
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let chartRadius = size / 2
            let ringThickness = chartRadius * (1.0 - DesignConstants.innerRadiusRatio)
            let cornerRadius = ringThickness / 2

            ZStack {
                Chart(entries) { entry in
                    SectorMark(
                        angle: .value("Value", entry.amount),
                        innerRadius: .ratio(DesignConstants.innerRadiusRatio),
                        outerRadius: .ratio(DesignConstants.outerRadiusRatio),
                        angularInset: DesignConstants.angularInset
                    )
                    .cornerRadius(cornerRadius)
                    .foregroundStyle(entry.option.color.color)
                }
                
                ForEach(entries) { entry in
                    Image(systemName: entry.option.iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: size * DesignConstants.iconSizeRatio,
                               height: size * DesignConstants.iconSizeRatio)
                        .position(iconPosition(for: entry, size: size))
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    // MARK: - Private Methods
    private func iconPosition(for entry: DrinkEntry, size: CGFloat) -> CGPoint {
        let total = Double(entries.reduce(0) { $0 + $1.amount })
        var angle: Double = DesignConstants.startAngle
        let center = size / 2
        
        let midRatio = Calculation.midRadiusRatio(
            inner: DesignConstants.innerRadiusRatio,
            outer: DesignConstants.outerRadiusRatio
        )
        let radius = size / 2 * midRatio
        
        for e in entries {
            guard e.id != entry.id else {
                let segmentHalf = (Double(e.amount) / total) * DesignConstants.degreesInHalfCircle
                let midAngle = angle + segmentHalf
                let radians = midAngle * DesignConstants.radiansToDegrees
                let x = center + CGFloat(cos(radians)) * radius
                let y = center + CGFloat(sin(radians)) * radius
                return CGPoint(x: x, y: y)
            }
            angle += (Double(e.amount) / total) * DesignConstants.degreesInCircle
        }
        
        return CGPoint(x: center, y: center)
    }
}

#Preview {
    ChartsProgressView(entries: [
        .init(option: VolumeOption(name: "Coffee", iconName: "cup.and.heat.waves", color: .coffee), amount: 150),
        .init(option: VolumeOption(name: "Glass", iconName: "cup.and.saucer", color: .lightBlue), amount: 600),
        .init(option: VolumeOption(name: "Juice", iconName: "mug", color: .peach), amount: 330)
    ])
    .padding(30)
}

import SwiftUI

struct RegionView: View {
    let region: Region
    let isSelected: Bool
    let hasSelection: Bool

    private var strokeColor: Color {
        if isSelected { return .white }
        return AppTheme.regionStroke.opacity(hasSelection ? 0.45 : 1)
    }

    var body: some View {
        let shape = RegionShape(points: region.points)
        let strokeStyle = StrokeStyle(lineWidth: isSelected ? 2.5 : 1.2, lineJoin: .round)

        PatternView(pattern: region.pattern)
            .clipShape(shape)
            .overlay(shape.stroke(strokeColor, style: strokeStyle))
            .contentShape(shape)
            .scaleEffect(isSelected ? 1.03 : 1)
            .opacity(hasSelection && !isSelected ? 0.35 : 1)
    }
}

import SwiftUI

struct RegionShape: Shape {
    let points: [CGPoint]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard let first = points.first else { return path }

        let sx = rect.width / 205
        let sy = rect.height / 180

        func map(_ pt: CGPoint) -> CGPoint {
            CGPoint(x: rect.minX + pt.x * sx, y: rect.minY + pt.y * sy)
        }

        path.move(to: map(first))
        for pt in points.dropFirst() {
            path.addLine(to: map(pt))
        }
        path.closeSubpath()
        return path
    }
}

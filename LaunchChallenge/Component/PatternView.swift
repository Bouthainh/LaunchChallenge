import SwiftUI

struct PatternView: View {
    let pattern: PatternType

    private let unit: CGFloat = 0.9
    private let spacing: CGFloat = 1.7

    var body: some View {
        Canvas { context, size in
            let bg = Path(CGRect(origin: .zero, size: size))
            context.fill(bg, with: .color(AppTheme.patternBase))

            let stepX = pattern.tile.width * unit * spacing
            let stepY = pattern.tile.height * unit * spacing

            var y: CGFloat = 0
            while y < size.height {
                var x: CGFloat = 0
                while x < size.width {
                    drawTile(in: context, origin: CGPoint(x: x, y: y))
                    x += stepX
                }
                y += stepY
            }
        }
    }

    private func drawTile(in context: GraphicsContext, origin: CGPoint) {
        switch pattern {
        case .triangles: drawTriangles(in: context, origin: origin)
        case .palm:      drawPalm(in: context, origin: origin)
        case .sun:       drawSun(in: context, origin: origin)
        case .wheel:     drawWheel(in: context, origin: origin)
        case .qatt:      drawQatt(in: context, origin: origin)
        }
    }

    private func pt(_ o: CGPoint, _ x: CGFloat, _ y: CGFloat) -> CGPoint {
        CGPoint(x: o.x + x * unit, y: o.y + y * unit)
    }

    private func circle(_ o: CGPoint, _ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat) -> Path {
        let c = pt(o, cx, cy)
        let rr = r * unit
        return Path(ellipseIn: CGRect(x: c.x - rr, y: c.y - rr, width: rr * 2, height: rr * 2))
    }

    private func drawTriangles(in context: GraphicsContext, origin o: CGPoint) {
        var path = Path()
        path.move(to: pt(o, 0.8, 9.2))
        path.addLine(to: pt(o, 5, 2.2))
        path.addLine(to: pt(o, 9.2, 9.2))
        path.closeSubpath()
        context.fill(path, with: .color(AppTheme.patternInk))
    }

    private func drawPalm(in context: GraphicsContext, origin o: CGPoint) {
        var path = Path()
        path.move(to: pt(o, 6, 0))
        path.addLine(to: pt(o, 6, 12))
        path.move(to: pt(o, 6, 5))
        path.addLine(to: pt(o, 1.5, 1))
        path.move(to: pt(o, 6, 5))
        path.addLine(to: pt(o, 10.5, 1))
        path.move(to: pt(o, 6, 11))
        path.addLine(to: pt(o, 1.5, 7))
        path.move(to: pt(o, 6, 11))
        path.addLine(to: pt(o, 10.5, 7))
        let style = StrokeStyle(lineWidth: 1.2 * unit, lineCap: .round)
        context.stroke(path, with: .color(AppTheme.patternInk), style: style)
    }

    private func drawSun(in context: GraphicsContext, origin o: CGPoint) {
        context.fill(circle(o, 12, 12, 2.6), with: .color(AppTheme.patternInk))
        context.stroke(circle(o, 12, 12, 4.4), with: .color(AppTheme.patternInk), lineWidth: unit)

        var rays = Path()
        for i in 0..<8 {
            let a = CGFloat(i) * .pi / 4
            let c = cos(a)
            let s = sin(a)
            rays.move(to: pt(o, 12 + 5.5 * c, 12 + 5.5 * s))
            rays.addLine(to: pt(o, 12 + 9 * c, 12 + 9 * s))
        }
        let style = StrokeStyle(lineWidth: 1.3 * unit, lineCap: .round)
        context.stroke(rays, with: .color(AppTheme.patternInk), style: style)
    }

    private func drawWheel(in context: GraphicsContext, origin o: CGPoint) {
        let ink = AppTheme.patternInk

        let squareRect = CGRect(
            x: o.x + 4 * unit, y: o.y + 4 * unit,
            width: 16 * unit, height: 16 * unit
        )
        context.stroke(Path(squareRect), with: .color(ink), lineWidth: unit)

        var diamond = Path()
        diamond.move(to: pt(o, 12, 0.5))
        diamond.addLine(to: pt(o, 23.5, 12))
        diamond.addLine(to: pt(o, 12, 23.5))
        diamond.addLine(to: pt(o, 0.5, 12))
        diamond.closeSubpath()
        context.stroke(diamond, with: .color(ink), lineWidth: unit)

        context.stroke(circle(o, 12, 12, 6.5), with: .color(ink), lineWidth: unit)

        var spokes = Path()
        for i in 0..<8 {
            let a = CGFloat(i) * .pi / 4
            spokes.move(to: pt(o, 12, 12))
            spokes.addLine(to: pt(o, 12 + 6.5 * cos(a), 12 + 6.5 * sin(a)))
        }
        context.stroke(spokes, with: .color(ink), lineWidth: unit)

        context.fill(circle(o, 12, 12, 1.2), with: .color(ink))
    }

    private func drawQatt(in context: GraphicsContext, origin o: CGPoint) {
        var lines = Path()
        lines.move(to: pt(o, 0, 2))
        lines.addLine(to: pt(o, 20, 2))
        lines.move(to: pt(o, 0, 14))
        lines.addLine(to: pt(o, 20, 14))
        context.stroke(lines, with: .color(AppTheme.patternInk), lineWidth: 1.2 * unit)

        var diamond = Path()
        diamond.move(to: pt(o, 10, 4.5))
        diamond.addLine(to: pt(o, 14.5, 8))
        diamond.addLine(to: pt(o, 10, 11.5))
        diamond.addLine(to: pt(o, 5.5, 8))
        diamond.closeSubpath()
        context.stroke(diamond, with: .color(AppTheme.patternInk), lineWidth: 1.2 * unit)
    }
}

import SwiftUI

/// The full puzzle page, built only from AppTheme / CanvasPalette (via PuzzleStyle).
/// Title, subtitle and instruction are parameters, so every region reuses this screen.
struct PuzzleScreen: View {
    let puzzle: PuzzleDefinition
    let rewardImage: String
    let title: String      // e.g. "Najd Mystery!": pass a different title per region
    var subtitle = "Put the pieces together and solve the mystery to earn your stamp"
    var instruction = "Touch and drag the pieces into right places"
    var onComplete: () -> Void = {}
    var onTabSelect: (AppTab) -> Void = { _ in }

    @Environment(\.dismiss) private var dismiss
    @State private var soundOn = true
    @State private var showReward = false

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                header
                    .padding(.horizontal, 34)

                boardArea

                InstructionLabel(text: instruction)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 14)

                StampsRow()
                    .offset(x: -12)
                    .padding(.top, 14)
                    .padding(.bottom, 8)
            }

            if showReward { rewardPopup }
        }
        .screenBackground()                       // your AppTheme background
        .safeAreaInset(edge: .bottom) {
            AppTabBar(onSelect: onTabSelect).padding(.bottom, 6)
        }
        .preferredColorScheme(.dark)
        .onChange(of: puzzle.puzzleId) { showReward = false }
    }

    // MARK: Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Spacer()
                Button { soundOn.toggle() } label: {
                    Image(systemName: soundOn ? "speaker.wave.2.fill" : "speaker.slash.fill")
                        .font(.system(size: 17))
                        .foregroundStyle(AppTheme.titleText)
                        .frame(width: 38, height: 38)
                        .background(Circle().fill(PuzzleStyle.controlFill))
                }
                .accessibilityLabel(soundOn ? "Mute sound" : "Unmute sound")
            }
            Text(title)
                .font(AppTheme.MainTitle)
                .foregroundStyle(AppTheme.titleText)
            Text(subtitle)
                .font(AppTheme.body)
                .foregroundStyle(AppTheme.bodyText)
                .frame(maxWidth: 290, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.bottom, 18)
    }

    // MARK: Board

    private var boardArea: some View {
        GeometryReader { geo in
            let pad: CGFloat = 22
            let tile = max(min((geo.size.width - 24 - pad * 2) / CGFloat(puzzle.columns),
                               (geo.size.height - pad * 2) / CGFloat(puzzle.rows)), 20)

            PuzzleBoardView(puzzle: puzzle, tile: tile, pad: pad, soundEnabled: soundOn) {
                onComplete()
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.5)) {
                    showReward = true
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .id(puzzle.puzzleId)   // a different puzzle always gets a fresh, reshuffled board
        }
    }

    // MARK: Reward

    private var rewardPopup: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Stamp unlocked!")
                    .font(AppTheme.MainTitle)
                    .foregroundStyle(AppTheme.titleText)
                Image(rewardImage)
                    .resizable().scaledToFit()
                    .frame(width: 140, height: 140)
                Button { dismiss() } label: {
                    Text("Continue")
                        .font(PuzzleStyle.instructionFont)
                        .foregroundStyle(AppTheme.background)
                        .padding(.horizontal, 32).padding(.vertical, 10)
                        .background(Capsule().fill(AppTheme.titleText))
                }
            }
            .padding(28)
            .background(RoundedRectangle(cornerRadius: 28).fill(AppTheme.background))
            .overlay(RoundedRectangle(cornerRadius: 28).stroke(PuzzleStyle.boardBorder, lineWidth: 1.2))
        }
        .transition(.scale(scale: 0.85).combined(with: .opacity))
    }
}

// MARK: - Instruction label

struct InstructionLabel: View {
    let text: String

    var body: some View {
        Text(text)
            .font(PuzzleStyle.instructionFont)
            .foregroundStyle(PuzzleStyle.instructionText)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .frame(width: 262)
            .background(RoundedRectangle(cornerRadius: 2).fill(PuzzleStyle.panelFill))
    }
}

// MARK: - Stamps row (uses your PatternType)

/// One stamp slot per pattern. Dimmed until the stamp is collected.
struct StampsRow: View {
    var stamps: [PatternType] = [.triangles, .sun, .qatt]
    var collected: [PatternType] = []

    var body: some View {
        HStack(spacing: 10) {
            ForEach(stamps, id: \.self) { type in
                PatternStamp(type: type, collected: collected.contains(type))
            }
        }
    }
}

/// A round stamp filled with a tiled pattern, laid out with `PatternType.tile`.
/// Colors come from AppTheme (patternBase / patternInk / regionStroke).
/// If you already have a view that draws these patterns, replace the Canvas with it.
struct PatternStamp: View {
    let type: PatternType
    var collected = false

    var body: some View {
        Canvas { ctx, size in
            let t = type.tile
            let columns = Int(ceil(size.width / t.width))
            let rows = Int(ceil(size.height / t.height))
            for r in 0..<rows {
                for c in 0..<columns {
                    let cell = CGRect(x: CGFloat(c) * t.width, y: CGFloat(r) * t.height,
                                      width: t.width, height: t.height)
                    ctx.fill(motif(in: cell), with: .color(AppTheme.patternInk),
                             style: FillStyle(eoFill: true))
                }
            }
        }
        .frame(width: 44, height: 44)
        .background(AppTheme.patternBase)
        .clipShape(Circle())
        .overlay(Circle().stroke(AppTheme.regionStroke, lineWidth: 1.5))
        .opacity(collected ? 1 : 0.45)
    }

    /// One repeat of the pattern inside `cell`.
    private func motif(in cell: CGRect) -> Path {
        let b = cell.insetBy(dx: cell.width * 0.12, dy: cell.height * 0.12)
        let c = CGPoint(x: b.midX, y: b.midY)
        let radius = min(b.width, b.height) / 2
        var p = Path()

        switch type {
        case .triangles:
            p.move(to: CGPoint(x: b.midX, y: b.minY))
            p.addLine(to: CGPoint(x: b.maxX, y: b.maxY))
            p.addLine(to: CGPoint(x: b.minX, y: b.maxY))
            p.closeSubpath()

        case .palm:   // leaf
            p.move(to: CGPoint(x: b.midX, y: b.minY))
            p.addQuadCurve(to: CGPoint(x: b.midX, y: b.maxY), control: CGPoint(x: b.maxX, y: b.midY))
            p.addQuadCurve(to: CGPoint(x: b.midX, y: b.minY), control: CGPoint(x: b.minX, y: b.midY))

        case .sun:    // disc + 8 rays
            p.addEllipse(in: CGRect(x: c.x - radius * 0.45, y: c.y - radius * 0.45,
                                    width: radius * 0.9, height: radius * 0.9))
            for i in 0..<8 {
                let a = Double(i) * .pi / 4
                func point(_ r: CGFloat, _ angle: Double) -> CGPoint {
                    CGPoint(x: c.x + r * CGFloat(cos(angle)), y: c.y + r * CGFloat(sin(angle)))
                }
                p.move(to: point(radius * 0.6, a - 0.25))
                p.addLine(to: point(radius, a))
                p.addLine(to: point(radius * 0.6, a + 0.25))
                p.closeSubpath()
            }

        case .wheel:  // ring + hub
            p.addEllipse(in: CGRect(x: c.x - radius * 0.95, y: c.y - radius * 0.95,
                                    width: radius * 1.9, height: radius * 1.9))
            p.addEllipse(in: CGRect(x: c.x - radius * 0.7, y: c.y - radius * 0.7,
                                    width: radius * 1.4, height: radius * 1.4))
            p.addEllipse(in: CGRect(x: c.x - radius * 0.25, y: c.y - radius * 0.25,
                                    width: radius * 0.5, height: radius * 0.5))

        case .qatt:   // diamond with a diamond cut out
            func diamond(_ k: CGFloat) -> Path {
                var d = Path()
                d.move(to: CGPoint(x: c.x, y: c.y - b.height / 2 * k))
                d.addLine(to: CGPoint(x: c.x + b.width / 2 * k, y: c.y))
                d.addLine(to: CGPoint(x: c.x, y: c.y + b.height / 2 * k))
                d.addLine(to: CGPoint(x: c.x - b.width / 2 * k, y: c.y))
                d.closeSubpath()
                return d
            }
            p.addPath(diamond(1))
            p.addPath(diamond(0.5))
        }
        return p
    }
}

// MARK: - Floating tab bar
// If your app already has a tab bar, delete this section and use yours.

enum AppTab: CaseIterable {
    case map, canvas, bag

    var label: String {
        switch self {
        case .map: return "Map"
        case .canvas: return "Canvas"
        case .bag: return "Bag"
        }
    }

    /// SF Symbols as stand-ins: replace with your own icons, e.g. Image("tab_map").
    var symbol: String {
        switch self {
        case .map: return "map.fill"
        case .canvas: return "paintbrush.pointed.fill"
        case .bag: return "briefcase.fill"
        }
    }
}

struct AppTabBar: View {
    var selected: AppTab? = nil          // selected tab uses AppTheme.tabSelected
    var onSelect: (AppTab) -> Void = { _ in }

    var body: some View {
        HStack(spacing: 34) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Button { onSelect(tab) } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.symbol).font(.system(size: 26))
                        Text(tab.label).font(PuzzleStyle.tabLabelFont)
                    }
                    .foregroundStyle(tab == selected ? AppTheme.tabSelected : PuzzleStyle.tabInk)
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 10)
        .frame(width: 277)
        .background(Capsule().fill(PuzzleStyle.tabBarFill))
        .overlay(Capsule().stroke(.white.opacity(0.08), lineWidth: 1))
    }
}

#Preview {
    PuzzleScreen(
        puzzle: PuzzleDefinition(puzzleId: "najd_puzzle", type: "jigsaw", image: "najd_puzzle",
                                 rows: 4, columns: 3,
                                 appearsAfterStationId: "najd_2", rewardStickerId: "sticker_najd"),
        rewardImage: "sticker_najd",
        title: "Najd Mystery!"
    )
}

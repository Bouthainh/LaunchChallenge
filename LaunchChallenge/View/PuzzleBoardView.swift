import SwiftUI
import AudioToolbox

/// The framed board + draggable pieces. Pieces start shuffled inside the board,
/// like the design, and snap into place when dropped near their correct slot.
/// No timer, no score, no penalties.
struct PuzzleBoardView: View {
    let puzzle: PuzzleDefinition
    let tile: CGFloat            // size of one square tile, in points
    let pad: CGFloat             // space between the frame and the grid
    let soundEnabled: Bool
    let onComplete: () -> Void

    private struct Piece: Identifiable {
        let id: Int              // row * columns + col
        let row: Int
        let col: Int
        var pos: CGPoint         // center, in TILE units (1.0 = one tile), relative to the grid
        var placed = false
    }

    @State private var pieces: [Piece]
    @State private var dragging: Int?
    private let space = "board"

    init(puzzle: PuzzleDefinition,
         tile: CGFloat,
         pad: CGFloat = 22,
         soundEnabled: Bool = true,
         onComplete: @escaping () -> Void = {}) {
        self.puzzle = puzzle
        self.tile = tile
        self.pad = pad
        self.soundEnabled = soundEnabled
        self.onComplete = onComplete
        _pieces = State(initialValue: Self.makePieces(rows: puzzle.rows, columns: puzzle.columns))
    }

    var body: some View {
        let gridSize = CGSize(width: tile * CGFloat(puzzle.columns), height: tile * CGFloat(puzzle.rows))

        ZStack(alignment: .topLeading) {
            // Frame: thin gold line, then dark gray fill
            RoundedRectangle(cornerRadius: 34).stroke(PuzzleStyle.boardBorder, lineWidth: 1.2)
            RoundedRectangle(cornerRadius: 28).fill(PuzzleStyle.boardFill).padding(7)

            ForEach(pieces) { piece in
                PuzzlePieceView(image: puzzle.image, row: piece.row, col: piece.col,
                                tile: tile, gridSize: gridSize, placed: piece.placed)
                    .position(x: pad + piece.pos.x * tile, y: pad + piece.pos.y * tile)
                    .zIndex(piece.placed ? 0 : (dragging == piece.id ? 2 : 1))
                    .allowsHitTesting(!piece.placed)
                    .gesture(drag(piece))
            }
        }
        .frame(width: gridSize.width + pad * 2, height: gridSize.height + pad * 2)
        .coordinateSpace(name: space)
    }

    // MARK: Setup

    /// Each piece starts in another piece's slot (none starts in its own).
    private static func makePieces(rows: Int, columns: Int) -> [Piece] {
        let n = rows * columns
        var slots = Array(0..<n)
        repeat { slots.shuffle() } while n > 1 && slots.enumerated().contains { $0.offset == $0.element }
        return (0..<n).map { i in
            Piece(id: i, row: i / columns, col: i % columns,
                  pos: CGPoint(x: CGFloat(slots[i] % columns) + 0.5,
                               y: CGFloat(slots[i] / columns) + 0.5))
        }
    }

    // MARK: Dragging & snapping

    private func drag(_ piece: Piece) -> some Gesture {
        DragGesture(coordinateSpace: .named(space))
            .onChanged { value in
                if dragging == nil { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
                dragging = piece.id
                pieces[piece.id].pos = CGPoint(x: (value.location.x - pad) / tile,
                                               y: (value.location.y - pad) / tile)
            }
            .onEnded { _ in
                dragging = nil
                let target = CGPoint(x: CGFloat(piece.col) + 0.5, y: CGFloat(piece.row) + 0.5)
                let now = pieces[piece.id].pos
                // Close enough to its slot? Snap. Otherwise it stays where it was dropped.
                guard hypot(now.x - target.x, now.y - target.y) < 0.4 else { return }

                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    pieces[piece.id].pos = target
                    pieces[piece.id].placed = true
                }
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                if soundEnabled { AudioServicesPlaySystemSound(1104) }   // swap for your snap sound

                if pieces.allSatisfy(\.placed) { finish() }
            }
    }

    private func finish() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        if soundEnabled { AudioServicesPlaySystemSound(1025) }           // swap for your victory sound
        onComplete()
    }
}

// MARK: - Piece look (REPLACE THIS to change the pieces later)

/// One piece = one slice of the full ornament image. Plain squares for now.
/// To switch to jigsaw pieces later, change only this view (e.g. clip with a custom Shape).
struct PuzzlePieceView: View {
    let image: String
    let row: Int
    let col: Int
    let tile: CGFloat
    let gridSize: CGSize
    let placed: Bool

    var body: some View {
        Image(image)
            .resizable()
            .scaledToFill()
            .frame(width: gridSize.width, height: gridSize.height)
            .clipped()
            .offset(x: -CGFloat(col) * tile, y: -CGFloat(row) * tile)
            .frame(width: tile, height: tile, alignment: .topLeading)
            .clipped()
            .background(AppTheme.titleText.opacity(0.3))   // visible even if the image asset is missing
            .overlay(Rectangle().stroke(.white, lineWidth: placed ? 0 : 2))
            .shadow(color: .black.opacity(placed ? 0 : 0.5), radius: 4, y: 2)
    }
}
#Preview {
    PuzzleBoardView(
        puzzle: PuzzleDefinition(
            puzzleId: "najd_puzzle", type: "jigsaw", image: "najd_puzzle",
            rows: 4, columns: 3,
            appearsAfterStationId: "najd_2", rewardStickerId: "sticker_najd"
        ),
        tile: 100                      // size of one square piece, in points
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppTheme.background)
}

import SwiftUI

@Observable
final class PuzzleViewModel {

    let puzzle: PuzzleModel
    var pieces: [PuzzlePiece]
    var draggingID: Int?
    var dragPoint: CGPoint = .zero
    var isSolved = false

    init(puzzle: PuzzleModel) {
        self.puzzle = puzzle
        let n = puzzle.rows * puzzle.columns
        var slots = Array(0..<n)
        repeat { slots.shuffle() } while n > 1 && slots.enumerated().contains { $0.offset == $0.element }
        pieces = (0..<n).map {
            PuzzlePiece(id: $0, row: $0 / puzzle.columns, col: $0 % puzzle.columns, slot: slots[$0])
        }
    }

    
    var rewardImage: String {
        ContentLoader.load()?.rewards.first { $0.rewardId == puzzle.rewardStickerId }?.image ?? ""
    }

    func center(ofSlot slot: Int) -> CGPoint {
        CGPoint(x: CGFloat(slot % puzzle.columns) + 0.5,
                y: CGFloat(slot / puzzle.columns) + 0.5)
    }

    func position(of piece: PuzzlePiece) -> CGPoint {
        draggingID == piece.id ? dragPoint : center(ofSlot: piece.slot)
    }

    func drag(_ id: Int, to point: CGPoint) {
        guard !pieces[id].isCorrect else { return }
        draggingID = id
        dragPoint = point
    }

 
    func drop(_ id: Int, at point: CGPoint) {
        draggingID = nil

        let col = min(max(Int(point.x.rounded(.down)), 0), puzzle.columns - 1)
        let row = min(max(Int(point.y.rounded(.down)), 0), puzzle.rows - 1)
        let target = row * puzzle.columns + col

        let oldSlot = pieces[id].slot
        guard target != oldSlot,
              let other = pieces.firstIndex(where: { $0.slot == target }),
              !pieces[other].isCorrect else { return }   

        pieces[other].slot = oldSlot
        pieces[id].slot = target

        isSolved = pieces.allSatisfy(\.isCorrect)
    }
}

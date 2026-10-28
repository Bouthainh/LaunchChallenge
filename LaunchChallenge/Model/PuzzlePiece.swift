
import Foundation

struct PuzzlePiece: Identifiable {
    
    let id: Int
    let row: Int
    let col: Int
    var slot: Int

    var isCorrect: Bool { slot == id }
}

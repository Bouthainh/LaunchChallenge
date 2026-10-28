import SwiftUI

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
            .overlay(Rectangle().stroke(.white.opacity(placed ? 0 : 0.8), lineWidth: 1.5))
    }
}

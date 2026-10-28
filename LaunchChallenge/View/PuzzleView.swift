import SwiftUI

struct PuzzleView: View {

    @State private var vm: PuzzleViewModel
    @State private var showReward = false
    @Environment(ProgressStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    let title: String
    var onQuit: () -> Void = {}

    private let pad: CGFloat = 22
    private let space = "board"

    init(puzzle: PuzzleModel, title: String, onQuit: @escaping () -> Void = {}) {
        _vm = State(initialValue: PuzzleViewModel(puzzle: puzzle))
        self.title = title
        self.onQuit = onQuit
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {

                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(AppTheme.MainTitle)
                        .foregroundStyle(AppTheme.titleText)
                    Text("رتّب القطع لتحلّ اللغز وتحصل على ملصقـك")
                        .font(AppTheme.body)
                        .foregroundStyle(AppTheme.bodyText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 34)
                .padding(.top, 90)

                board

                Text("اسحب القطعة وأفلتهـا فوق قطعـة أخرى لتبديلهمـا")
                    .font(AppTheme.instructionFont)
                    .foregroundStyle(AppTheme.instructionText)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 90)
            }

            if showReward { rewardPopup }
        }
        .backgroundDesign(.bottomLeft, width: 140, offset: 14)
        .screenBackground()
        .overlay(alignment: .topLeading) {
            Button {
                dismiss()
                onQuit()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppTheme.tabSelected)
                    .frame(width: 40, height: 40)
                    .background(.ultraThinMaterial, in: Circle())
                    .background(AppTheme.background.opacity(0.4), in: Circle())            }
            .padding(.leading, 20)
            .padding(.top, 30)
        }
        .onChange(of: vm.isSolved) { _, solved in
            guard solved else { return }
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            store.collect(vm.puzzle.rewardStickerId)
            Task {
                try? await Task.sleep(for: .seconds(3.5))
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    showReward = true
                }
            }
        }
    }

    // MARK: Board

    private var board: some View {
        GeometryReader { geo in
            let cols = CGFloat(vm.puzzle.columns)
            let rows = CGFloat(vm.puzzle.rows)
            let tile = max(min((geo.size.width - 24 - pad * 2) / cols,
                               (geo.size.height - pad * 2) / rows), 20)
            let gridSize = CGSize(width: tile * cols, height: tile * rows)

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 34)
                    .stroke(AppTheme.boardBorder, lineWidth: 1.2)
                RoundedRectangle(cornerRadius: 28)
                    .fill(AppTheme.boardFill)
                    .padding(7)

                ForEach(vm.pieces) { piece in
                    let p = vm.position(of: piece)

                    PuzzlePieceView(image: vm.puzzle.image, row: piece.row, col: piece.col,
                                    tile: tile, gridSize: gridSize, placed: piece.isCorrect)
                        .shadow(color: .black.opacity(vm.draggingID == piece.id ? 0.5 : 0), radius: 6)
                        .position(x: pad + p.x * tile, y: pad + p.y * tile)
                        .zIndex(vm.draggingID == piece.id ? 2 : 1)
                        .allowsHitTesting(!piece.isCorrect)
                        .gesture(
                            DragGesture(coordinateSpace: .named(space))
                                .onChanged { value in
                                    vm.drag(piece.id, to: CGPoint(x: (value.location.x - pad) / tile,
                                                                  y: (value.location.y - pad) / tile))
                                }
                                .onEnded { value in
                                    let point = CGPoint(x: (value.location.x - pad) / tile,
                                                        y: (value.location.y - pad) / tile)
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        vm.drop(piece.id, at: point)
                                    }
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                }
                        )
                }
            }
            .frame(width: gridSize.width + pad * 2, height: gridSize.height + pad * 2)
            .coordinateSpace(name: space)
            .environment(\.layoutDirection, .leftToRight)   // the board never mirrors
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // MARK: Reward

    private var rewardPopup: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            VStack(spacing: 16) {
                Text("حصلت على ملصـق جديـد!")
                    .font(AppTheme.MainTitle)
                    .foregroundStyle(AppTheme.titleText)
                Image(vm.rewardImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                Button("متابعـة") { dismiss() }
                    .font(AppTheme.instructionFont)
                    .foregroundStyle(AppTheme.background)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(AppTheme.titleText))
            }
            .padding(28)
            .background(RoundedRectangle(cornerRadius: 28).fill(AppTheme.background))
            .overlay(RoundedRectangle(cornerRadius: 28).stroke(AppTheme.boardBorder, lineWidth: 1.2))
        }
        .transition(.scale(scale: 0.85).combined(with: .opacity))
    }
}

#Preview {
    let puzzle = ContentLoader.load()!.galleries[1].puzzle
    PuzzleView(puzzle: puzzle, title: "لغز نجد")
        .environment(ProgressStore())
}

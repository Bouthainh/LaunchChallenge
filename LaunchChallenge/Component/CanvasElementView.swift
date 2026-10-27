import SwiftUI

struct CanvasElementView: View {
    @Binding var element: CanvasElement
    @State private var resizeStart: CGFloat?

    let isSelected: Bool
    let onSelect: () -> Void
    let onEdit: () -> Void
    let onFont: () -> Void
    let onTextColor: () -> Void
    let onFront: () -> Void
    let onDelete: () -> Void

    @GestureState private var dragOffset: CGSize = .zero
    @GestureState private var pinchScale: CGFloat = 1
    @GestureState private var twistAngle: Angle = .zero

    var body: some View {
        content
            .padding(6)
            .overlay(selectionBorder)
            .overlay(alignment: .bottomTrailing) {
                if isSelected {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(AppTheme.background)
                        .frame(width: 26, height: 26)
                        .background(Circle().fill(AppTheme.tabSelected))
                        .scaleEffect(1 / element.scale)
                        .offset(x: 10, y: 10)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let base = resizeStart ?? element.scale
                                    resizeStart = base
                                    let change = (value.translation.width + value.translation.height) / 120
                                    element.scale = min(max(base + change, 0.3), 6)
                                }
                                .onEnded { _ in resizeStart = nil }
                        )
                }
            }
            .scaleEffect(element.scale * pinchScale)
            .rotationEffect(element.rotation + twistAngle)
            .offset(x: element.offset.width + dragOffset.width,
                    y: element.offset.height + dragOffset.height)
            .gesture(drag)
            .simultaneousGesture(pinch)
            .simultaneousGesture(twist)
            .onTapGesture {
                if isSelected && element.isText { onEdit() } else { onSelect() }
            }
            .contextMenu {
                if element.isText {
                    Button(action: onEdit) { Label("تعديل النص", systemImage: "pencil") }
                    Button(action: onFont) { Label("الخط والحجم", systemImage: "textformat") }
                    Button(action: onTextColor) { Label("لون النص", systemImage: "paintpalette") }
                }
                Button(action: onFront) { Label("إحضار للأمام", systemImage: "arrow.up.to.line") }
                Button(role: .destructive, action: onDelete) { Label("حذف", systemImage: "trash") }
            }
    }

    @ViewBuilder
    private var content: some View {
        switch element.kind {
        case .sticker(let sticker):
            Image(sticker.image)
                .resizable()
                .scaledToFit()
                .frame(width: 110, height: 110)
        case .text(let string):
            Text(string)
                .font(element.font)
                .foregroundStyle(element.color)
        }
    }

    @ViewBuilder
    private var selectionBorder: some View {
        if isSelected {
            RoundedRectangle(cornerRadius: 6)
                .stroke(AppTheme.tabSelected,
                        style: StrokeStyle(lineWidth: 1.5, dash: [5, 4]))
        }
    }

    private var drag: some Gesture {
        DragGesture()
            .onChanged { _ in if !isSelected { onSelect() } }
            .updating($dragOffset) { value, state, _ in state = value.translation }
            .onEnded { value in
                element.offset.width += value.translation.width
                element.offset.height += value.translation.height
            }
    }

    private var pinch: some Gesture {
        MagnificationGesture()
            .updating($pinchScale) { value, state, _ in state = value }
            .onEnded { value in
                element.scale = min(max(element.scale * value, 0.3), 6)
            }
    }

    private var twist: some Gesture {
        RotationGesture()
            .updating($twistAngle) { value, state, _ in state = value }
            .onEnded { value in element.rotation = element.rotation + value }
    }
}

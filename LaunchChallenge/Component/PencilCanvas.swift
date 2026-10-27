import SwiftUI
import PencilKit

struct PencilCanvas: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    var isActive: Bool

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.drawingPolicy = .anyInput
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        canvas.drawing = drawing
        canvas.delegate = context.coordinator
        context.coordinator.toolPicker.addObserver(canvas)
        return canvas
    }

    func updateUIView(_ canvas: PKCanvasView, context: Context) {
        if canvas.drawing != drawing { canvas.drawing = drawing }
        canvas.isUserInteractionEnabled = isActive

        let picker = context.coordinator.toolPicker
        picker.setVisible(isActive, forFirstResponder: canvas)

        if isActive {
            DispatchQueue.main.async { canvas.becomeFirstResponder() }
        } else {
            canvas.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PencilCanvas
        let toolPicker = PKToolPicker()
        init(_ parent: PencilCanvas) { self.parent = parent }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.drawing = canvasView.drawing
        }
    }
}

import SwiftUI
import PencilKit

@Observable
final class CanvasViewModel {

    var showTitle = true
    var showSubtitle = true
    
    enum Sheet: String, Identifiable {
        case bag, colors, font
        var id: String { rawValue }
    }

    var elements: [CanvasElement] = []

    var drawing = PKDrawing()
    var isDrawing = false
    var selectedID: UUID?
    var canvasColor: Color = AppTheme.background
    var sheet: Sheet?
    var showTextAlert = false
    var textDraft = ""
    var editingID: UUID?

    var availableStickers: [RewardModel] {
        ContentLoader.load()?.rewards ?? []
    }

    private var selectedIndex: Int? {
        elements.firstIndex { $0.id == selectedID }
    }

    var selectedText: CanvasElement? {
        guard let i = selectedIndex, elements[i].isText else { return nil }
        return elements[i]
    }

    func addSticker(_ sticker: RewardModel) {
        let element = CanvasElement(kind: .sticker(sticker))
        elements.append(element)
        selectedID = element.id
    }

    func startAddingText() {
        isDrawing = false
        editingID = nil
        textDraft = ""
        showTextAlert = true
    }

    func startEditing(_ id: UUID) {
        guard let element = elements.first(where: { $0.id == id }),
              case .text(let string) = element.kind else { return }
        editingID = id
        textDraft = string
        showTextAlert = true
    }

    func commitText() {
        let text = textDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        defer { textDraft = ""; editingID = nil }
        guard !text.isEmpty else { return }

        if let id = editingID,
           let i = elements.firstIndex(where: { $0.id == id }) {
            elements[i].kind = .text(text)
        } else {
            let element = CanvasElement(kind: .text(text))
            elements.append(element)
            selectedID = element.id
        }
    }

    func applyColor(_ color: Color) {
        if let i = selectedIndex, elements[i].isText {
            elements[i].color = color
        } else {
            canvasColor = color
        }
    }

    func bringToFront(_ id: UUID) {
        guard let i = elements.firstIndex(where: { $0.id == id }) else { return }
        elements.append(elements.remove(at: i))
    }

    func delete(_ id: UUID) {
        elements.removeAll { $0.id == id }
        if selectedID == id { selectedID = nil }
    }

    func select(_ id: UUID, opening newSheet: Sheet? = nil) {
        selectedID = id
        if let newSheet { sheet = newSheet }
    }

    var fontStyleBinding: Binding<CanvasFontStyle> {
        Binding(
            get: { self.selectedText?.fontStyle ?? .display },
            set: { new in
                if let i = self.selectedIndex, self.elements[i].isText {
                    self.elements[i].fontStyle = new
                }
            })
    }

    var fontSizeBinding: Binding<CGFloat> {
        Binding(
            get: { self.selectedText?.fontSize ?? 32 },
            set: { new in
                if let i = self.selectedIndex, self.elements[i].isText {
                    self.elements[i].fontSize = new
                }
            })
    }
}

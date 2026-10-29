import SwiftUI
import PencilKit
import UIKit

@Observable
final class CanvasViewModel {

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
    var showTitle = true
    var showSubtitle = true

    private let saveKey = "savedCanvas"

    init() { load() }

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
        save()
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
        save()
    }

    func applyColor(_ color: Color) {
        if let i = selectedIndex, elements[i].isText {
            elements[i].color = color
        } else {
            canvasColor = color
        }
        save()
    }

    func bringToFront(_ id: UUID) {
        guard let i = elements.firstIndex(where: { $0.id == id }) else { return }
        elements.append(elements.remove(at: i))
        save()
    }

    func delete(_ id: UUID) {
        elements.removeAll { $0.id == id }
        if selectedID == id { selectedID = nil }
        save()
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


    private func rgb(_ color: Color) -> [Double] {
        let c = UIColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        c.getRed(&r, green: &g, blue: &b, alpha: &a)
        return [r, g, b]
    }

    private func color(_ v: [Double]) -> Color {
        v.count == 3 ? Color(red: v[0], green: v[1], blue: v[2]) : AppTheme.bodyText
    }

    //saving user canvas
    func save() {
        let items = elements.map { e -> SavedElement in
            var kind = "text", value = "", image = ""
            switch e.kind {
            case .text(let s): value = s
            case .sticker(let r): kind = "sticker"; value = r.rewardId; image = r.image
            }
            return SavedElement(kind: kind, value: value, image: image,
                                x: e.offset.width, y: e.offset.height,
                                scale: e.scale, rotation: e.rotation.radians,
                                colorHex: rgb(e.color),
                                fontIsDisplay: e.fontStyle == .display,
                                fontSize: e.fontSize)
        }
        let saved = SavedCanvas(elements: items,
                                background: rgb(canvasColor),
                                showTitle: showTitle,
                                showSubtitle: showSubtitle,
                                drawing: drawing.dataRepresentation())
        if let data = try? JSONEncoder().encode(saved) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    //loading user saved canvas
    func load() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let saved = try? JSONDecoder().decode(SavedCanvas.self, from: data) else { return }

        elements = saved.elements.map { s in
            var e = CanvasElement(kind: s.kind == "text"
                ? .text(s.value)
                : .sticker(RewardModel(rewardId: s.value, image: s.image)))
            e.offset = CGSize(width: s.x, height: s.y)
            e.scale = s.scale
            e.rotation = .radians(s.rotation)
            e.color = color(s.colorHex)
            e.fontStyle = s.fontIsDisplay ? .display : .text
            e.fontSize = s.fontSize
            return e
        }
        canvasColor = color(saved.background)
        showTitle = saved.showTitle
        showSubtitle = saved.showSubtitle
        if let d = try? PKDrawing(data: saved.drawing) { drawing = d }
    }
}

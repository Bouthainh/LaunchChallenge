import SwiftUI

struct CanvasElement: Identifiable {
    enum Kind {
        case sticker(RewardModel)
        case text(String)
    }

    let id = UUID()
    var kind: Kind
    var offset: CGSize = .zero
    var scale: CGFloat = 1
    var rotation: Angle = .zero
    var color: Color = AppTheme.bodyText
    var fontStyle: CanvasFontStyle = .display
    var fontSize: CGFloat = 32

    var isText: Bool {
        if case .text = kind { return true }
        return false
    }

    var font: Font { .custom(fontStyle.fontName, size: fontSize) }
}

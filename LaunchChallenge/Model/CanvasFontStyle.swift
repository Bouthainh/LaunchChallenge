import SwiftUI

enum CanvasFontStyle: CaseIterable, Identifiable {
    case display, text

    var id: Self { self }

    var title: String {
        switch self {
        case .display: return "عناوين"
        case .text:    return "نص"
        }
    }

    var fontName: String {
        switch self {
        case .display: return AppTheme.displayFontName
        case .text:    return AppTheme.textFontName
        }
    }
}

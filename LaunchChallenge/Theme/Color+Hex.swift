import SwiftUI

extension Color {
    init(hex: UInt) {
        self.init(red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255)
    }
}

enum CanvasPalette {
    static let colors: [Color] = [
        Color(hex: 0xFFFEFA), Color(hex: 0xFFF0AF),
        Color(hex: 0xDCCDB9), Color(hex: 0xD4923A),
        Color(hex: 0x8D0801), Color(hex: 0x7A1626),
        Color(hex: 0x63895B), Color(hex: 0x3E6F7C),
        Color(hex: 0x365C67), Color(hex: 0x141414)
    ]
}

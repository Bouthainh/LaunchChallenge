import SwiftUI

enum PatternType {
    case triangles
    case palm
    case sun
    case wheel
    case qatt

    var tile: CGSize {
        switch self {
        case .triangles: return CGSize(width: 10, height: 10)
        case .palm:      return CGSize(width: 12, height: 12)
        case .sun:       return CGSize(width: 24, height: 24)
        case .wheel:     return CGSize(width: 24, height: 24)
        case .qatt:      return CGSize(width: 20, height: 16)
        }
    }
}

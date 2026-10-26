import SwiftUI

enum Region: String, CaseIterable, Identifiable {
    case north, east, central, west, south

    var id: String { rawValue }

    var pattern: PatternType {
        switch self {
        case .north:   return .triangles
        case .east:    return .palm
        case .central: return .sun
        case .west:    return .wheel
        case .south:   return .qatt
        }
    }

    // The link between the map and your JSON
    var galleryId: String? {
        switch self {
        case .central: return "najd"
        default:       return nil
        }
    }

    var points: [CGPoint] {
        let flat: [CGFloat]
        switch self {
        case .north:
            flat = [23, 8, 44, 0, 56, 2, 96, 32, 98, 38, 97, 51, 68, 77, 55, 75, 54, 64,
                    44, 52, 35, 57, 30, 62, 8, 50, 2, 48, 4, 36, 26, 24, 36, 20, 28, 15]
        case .east:
            flat = [98, 38, 122, 37, 133, 47, 146, 63, 148, 74, 161, 86, 170, 102, 196, 105,
                    203, 115, 197, 138, 166, 150, 161, 144, 122, 142, 125, 116, 128, 87,
                    123, 81, 124, 63, 97, 51]
        case .central:
            flat = [97, 51, 124, 63, 123, 81, 128, 87, 125, 116, 122, 142, 101, 142,
                    92, 138, 90, 129, 88, 128, 86, 106, 74, 88, 68, 77]
        case .west:
            flat = [8, 50, 30, 62, 35, 57, 44, 52, 54, 64, 55, 75, 68, 77, 74, 88, 86, 106,
                    88, 128, 61, 131, 44, 126, 38, 102, 32, 88, 26, 76]
        case .south:
            flat = [44, 126, 61, 131, 88, 128, 90, 129, 92, 138, 101, 142, 122, 142, 161, 144,
                    166, 150, 126, 156, 116, 172, 84, 170, 80, 179, 74, 174, 58, 142]
        }
        return stride(from: 0, to: flat.count, by: 2).map {
            CGPoint(x: flat[$0], y: flat[$0 + 1])
        }
    }
}

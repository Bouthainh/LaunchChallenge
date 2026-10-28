import Foundation

extension Region {
    var title: String {
        switch self {
        case .north:   return "الشمالية"
        case .east:    return "الشرقية"
        case .central: return "الوسطى"
        case .west:    return "الغربية"
        case .south:   return "الجنوبية"
        }
    }
}

import SwiftUI
import Combine

final class UnlockStore: ObservableObject {
    static let shared = UnlockStore()
    @Published var isUnlocked = false
}

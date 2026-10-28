import Foundation
import Observation

@Observable
final class ProgressStore {
    private(set) var collectedIDs: Set<String>
    private(set) var seenIDs: Set<String>
    private(set) var completedRegions: Set<Region>

    @ObservationIgnored private let defaults: UserDefaults

    private enum Keys {
        static let collected = "collectedIDs"
        static let seen = "seenIDs"
        static let regions = "completedRegions"
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        collectedIDs = Set(defaults.stringArray(forKey: Keys.collected) ?? [])
        seenIDs = Set(defaults.stringArray(forKey: Keys.seen) ?? [])
        completedRegions = Set((defaults.stringArray(forKey: Keys.regions) ?? [])
            .compactMap(Region.init(rawValue:)))
    }

    // MARK: - Reading
    func state(of item: BagItem) -> ItemState {
        guard collectedIDs.contains(item.id) else { return .locked }
        return seenIDs.contains(item.id) ? .collected : .new
    }

    var completedCount: Int { completedRegions.count }
    var totalRegions: Int { Region.allCases.count }
    var progress: Double { Double(completedCount) / Double(totalRegions) }

    // MARK: - Changing (نناديها من الـ Map والـ Puzzle)
    func collect(id: String) { collectedIDs.insert(id); save() }
    func markSeen(_ item: BagItem) { seenIDs.insert(item.id); save() }
    func complete(_ region: Region) { completedRegions.insert(region); save() }

    func reset() {
        collectedIDs = []; seenIDs = []; completedRegions = []
        save()
    }

    // MARK: - Demo
    func seedDemoIfEmpty() {
        guard collectedIDs.isEmpty else { return }
        collectedIDs = ["west_nested_squares", "central_sun", "east_triangle_palm", "north_wavy_diamond"]
        seenIDs = ["central_sun", "east_triangle_palm", "north_wavy_diamond"]
        completedRegions = [.west]
        save()
    }

    static var preview: ProgressStore {
        let store = ProgressStore(defaults: UserDefaults(suiteName: "preview") ?? .standard)
        store.reset()
        store.seedDemoIfEmpty()
        return store
    }

    // MARK: - Saving
    private func save() {
        defaults.set(Array(collectedIDs), forKey: Keys.collected)
        defaults.set(Array(seenIDs), forKey: Keys.seen)
        defaults.set(completedRegions.map(\.rawValue), forKey: Keys.regions)
    }
}

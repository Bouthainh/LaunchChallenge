import Foundation
import Observation

enum ItemState { case locked, new, collected }

@Observable
final class ProgressStore {
    private(set) var collected: Set<String>   // rewardIds earned
    private(set) var seen: Set<String>         // stickers opened in the Bag
    private(set) var completed: Set<String>    // galleryIds finished
    private(set) var finaleShown: Bool

    @ObservationIgnored private let defaults = UserDefaults.standard

    init() {
        collected = Set(defaults.stringArray(forKey: "collected") ?? [])
        seen = Set(defaults.stringArray(forKey: "seen") ?? [])
        completed = Set(defaults.stringArray(forKey: "completed") ?? [])
        finaleShown = defaults.bool(forKey: "finaleShown")
    }

    func has(_ rewardId: String) -> Bool { collected.contains(rewardId) }

    func state(of reward: RewardModel) -> ItemState {
        guard has(reward.rewardId) else { return .locked }
        return seen.contains(reward.rewardId) ? .collected : .new
    }

    func collect(_ id: String)   { collected.insert(id); save() }
    func markSeen(_ id: String)  { seen.insert(id); save() }
    func complete(_ id: String)  { completed.insert(id); save() }
    func markFinaleShown() { finaleShown = true; save() }

    func reset() { collected = []; seen = []; completed = []; finaleShown = false; save() }

    private func save() {
        defaults.set(Array(collected), forKey: "collected")
        defaults.set(Array(seen), forKey: "seen")
        defaults.set(Array(completed), forKey: "completed")
        defaults.set(finaleShown, forKey: "finaleShown")
    }
}

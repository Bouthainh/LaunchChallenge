//
//  StampStore.swift
//  LaunchChallenge
//
//  Created by Hajar Mudhi  on 17/05/1448 AH.
//


import SwiftUI
import Observation

/// Remembers which stamps the user has earned. Saved in UserDefaults,
/// so the stamps are still there after the app is closed.
@MainActor
@Observable
final class StampStore {
    private(set) var collectedIDs: Set<String>
    private let key = "collectedStamps"

    init() {
        collectedIDs = Set(UserDefaults.standard.stringArray(forKey: key) ?? [])
    }

    /// Call with `puzzle.rewardStickerId` when a puzzle is solved.
    func collect(_ rewardID: String) {
        collectedIDs.insert(rewardID)
        UserDefaults.standard.set(Array(collectedIDs), forKey: key)
    }

    func has(_ rewardID: String) -> Bool {
        collectedIDs.contains(rewardID)
    }
}

/// Shows every stamp from `rewards`: earned ones in full color, the rest dimmed.
/// Use it in the Bag screen or anywhere you list stamps.
struct StampsGrid: View {
    let rewards: [RewardModel]
    @Environment(StampStore.self) private var stamps

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 16)], spacing: 16) {
            ForEach(rewards) { reward in
                Image(reward.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 90)
                    .opacity(stamps.has(reward.rewardId) ? 1 : 0.25)
            }
        }
        .padding()
    }
}
import Foundation

// Names match your JSON keys exactly, so decoding needs no extra setup.

struct PuzzleDefinition: Codable, Identifiable {
    let puzzleId: String
    let type: String
    let image: String
    let rows: Int
    let columns: Int
    let appearsAfterStationId: String
    let rewardStickerId: String

    var id: String { puzzleId }
}

struct RewardDefinition: Codable, Identifiable {
    let rewardId: String
    let image: String

    var id: String { rewardId }
}

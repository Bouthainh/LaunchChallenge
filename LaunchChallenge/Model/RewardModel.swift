import Foundation

struct RewardModel: Codable, Identifiable {
    
    let rewardId: String
    let image: String
    var id: String { rewardId }
}

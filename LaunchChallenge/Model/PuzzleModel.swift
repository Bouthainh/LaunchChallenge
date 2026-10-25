import Foundation

struct PuzzleModel : Codable {
    
    let puzzleId : String
    let type : String
    let image : String
    let rows : Int
    let columns : Int
    let appearsAfterStation : String
    let rewardStickerId : String
    
}


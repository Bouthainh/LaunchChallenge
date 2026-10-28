import Foundation

struct GalleryModel: Codable {
    let galleryId: String
    let galleryName: String
    let region: String
    let stations: [StationModel]
    let puzzle: PuzzleModel
}
    


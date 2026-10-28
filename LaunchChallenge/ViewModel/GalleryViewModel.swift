import SwiftUI
import Combine

//ObservableObject can publish changes for UI to observe
class GalleryViewModel: ObservableObject {
    
    // the station the lock sits after (appearsAfterStationId)
    var stationBeforeLock: StationModel? {
        guard let id = gallery?.puzzle.appearsAfterStationId else { return nil }
        return stations.first { $0.stationId == id }
    }
    //store the chosen gallery info
    let gallery: GalleryModel?
    @Published var currentIndex = 0

    //tell which gallery chosen by the user, then ask loader to load that data
    init(galleryId: String) {
        let content = ContentLoader.load()
        gallery = content?.galleries.first(where: { $0.galleryId == galleryId })
    }
    //access the stations within the gallery and stor it in array
    var stations: [StationModel] {
        gallery?.stations ?? []
    }
    
    func isLocked(_ index: Int, store: ProgressStore) -> Bool {
        guard let gallery,
              let after = stations.firstIndex(where: { $0.stationId == gallery.puzzle.appearsAfterStationId })
        else { return false }
        return index > after && !store.has(gallery.puzzle.rewardStickerId)
    }

}

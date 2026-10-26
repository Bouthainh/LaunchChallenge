import SwiftUI
import Combine

//ObservableObject can publish changes for UI to observe
class GalleryViewModel: ObservableObject {

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
}

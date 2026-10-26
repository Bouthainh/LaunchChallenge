import SwiftUI

//the vertical, swipeable gallery
struct GalleryView: View {

    @State private var scrolledId: String?

    //manage the updates of the observable obj
    @StateObject private var viewModel: GalleryViewModel

    init(galleryId: String) {
        _viewModel = StateObject(wrappedValue: GalleryViewModel(galleryId: galleryId))
    }
    
    private var currentIndex: Int {
        let id = scrolledId ?? viewModel.stations.first?.stationId
        return viewModel.stations.firstIndex(where: { $0.stationId == id }) ?? 0
    }

    var body: some View {
        // scroll ability to the gallery, containing each station
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.stations, id: \.stationId) { station in
                    StationView(station: station)
                        .containerRelativeFrame([.horizontal, .vertical])
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $scrolledId)
        .overlay(alignment: .topTrailing) {
            StationProgressBar(total: viewModel.stations.count, current: currentIndex)
                .padding(.top, 150)
                .padding(.leading, 10)
                .environment(\.layoutDirection, .leftToRight)
        }
        .scrollIndicators(.hidden)
        .toolbar(.hidden, for: .tabBar)
        .ignoresSafeArea()
    }
}

#Preview {
    GalleryView(galleryId: "najd")
        .environment(\.layoutDirection, .rightToLeft)
}

/*
 This View:
 - Own the ViewModel.
 - Loop through its stations.
 - Fill the screen with each station.
- Page between stations when the user swipes.
 */

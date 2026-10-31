import SwiftUI

//the vertical, swipeable gallery
struct GalleryView: View {

    @State private var scrolledId: String?
    @State private var showPuzzle = false

    //manage the updates of the observable obj
    @StateObject private var viewModel: GalleryViewModel
    @Environment(ProgressStore.self) private var store
    
    @Environment(MapViewModel.self) private var map
    @State private var showEnd = false
    @State private var endDismissed = false

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
                ForEach(Array(viewModel.stations.enumerated()), id: \.element.stationId) { index, station in
                    Group {
                        if viewModel.isLocked(index, store: store) {
                            LockedStationView { showPuzzle = true }
                        } else {
                            StationView(station: station)
                        }
                    }
                    .containerRelativeFrame([.horizontal, .vertical])
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $scrolledId)
        .scrollIndicators(.hidden)
        .fullScreenCover(isPresented: $showPuzzle) {
            if let gallery = viewModel.gallery {
                PuzzleView(puzzle: gallery.puzzle, title: gallery.galleryName) {
                    withAnimation { scrolledId = viewModel.stationBeforeLock?.stationId }
                }
                .environment(store)
                .environment(\.layoutDirection, .rightToLeft)
            }
        }
        .onChange(of: currentIndex) { _, index in
            // reaching the last station = gallery explored
            if index == viewModel.stations.count - 1,
               !viewModel.isLocked(index, store: store),
               let gallery = viewModel.gallery {
                store.complete(gallery.galleryId)
            }
        }
        .task(id: currentIndex) {
            // show the end pop-up only after the user stays on the last station
            guard currentIndex == viewModel.stations.count - 1,
                  !viewModel.isLocked(currentIndex, store: store) else { return }
            
            guard !endDismissed,
                  currentIndex == viewModel.stations.count - 1,
                  !viewModel.isLocked(currentIndex, store: store) else { return }
            
            try? await Task.sleep(for: .seconds(5))
            guard !Task.isCancelled else { return }
            withAnimation { showEnd = true }
        }
        .overlay(alignment: .topTrailing) {
            StationProgressBar(total: viewModel.stations.count, current: currentIndex)
                .padding(.top, 150)
                .padding(.leading, 10)
                .environment(\.layoutDirection, .leftToRight)
        }
        .overlay {
            if showEnd {
                EndOfGalleryView(
                    onBack: { map.openRegion = nil },
                    onStay: { withAnimation { showEnd = false; endDismissed = true } }                )
                .transition(.opacity)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .ignoresSafeArea()
    }
}

#Preview {
    GalleryView(galleryId: "najd")
        .environment(ProgressStore())
        .environment(\.layoutDirection, .rightToLeft)
}

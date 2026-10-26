import SwiftUI

@Observable
final class MapViewModel {
    var selectedRegion: Region?
    var openRegion: Region?

    func tap(_ region: Region) {
        withAnimation(.easeOut(duration: 0.2)) {
            selectedRegion = region
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            self?.openRegion = region
        }
    }

    func regionClosed() {
        selectedRegion = nil
    }
}

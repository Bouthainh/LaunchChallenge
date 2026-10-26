import SwiftUI

struct MapShapeView: View {
    let selected: Region?
    let onTap: (Region) -> Void

    var body: some View {
        ZStack {
            ForEach(Region.allCases) { region in
                RegionView(
                    region: region,
                    isSelected: selected == region,
                    hasSelection: selected != nil
                )
                .zIndex(selected == region ? 1 : 0)
                .onTapGesture { onTap(region) }
            }
        }
        .aspectRatio(205.0 / 180.0, contentMode: .fit)
    }
}

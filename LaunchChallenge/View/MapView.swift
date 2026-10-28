import SwiftUI

struct MapView: View {
    @State private var vm = MapViewModel()
    
    @Environment(ProgressStore.self) private var store
    @State private var showFinale = false
    private let totalGalleries = ContentLoader.load()?.galleries.count ?? 0

    var body: some View {
        @Bindable var vm = vm

        NavigationStack {
            VStack(alignment: .leading, spacing: 8) {

                Text("المملكة العربية السعوديـــة")
                    .font(AppTheme.MainTitle)
                    .foregroundStyle(AppTheme.titleText)

                Text("خريطـة الزخارف التراثيـة")
                    .font(AppTheme.Mainbody)
                    .foregroundStyle(AppTheme.bodyText)
                    .multilineTextAlignment(.leading)

                Spacer()

                MapShapeView(selected: vm.selectedRegion, onTap: vm.tap)
                    .environment(\.layoutDirection, .leftToRight)

                Spacer()

                HStack(spacing: 12) {
                    Image("compass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)

                    Text("اختر منطقـة لكي تبدأ رحلتـك الشيقة في معارض الزخـــارف السعوديـــة")
                        .font(AppTheme.body)
                        .foregroundStyle(AppTheme.bodyText)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 90)
            .padding(.bottom, 90)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .backgroundDesign(.topRight, width: 120, offset: 5)
            .screenBackground()
            .navigationDestination(item: $vm.openRegion) { region in
                if let id = region.galleryId {
                    GalleryIntroView(region: region, galleryId: id)
                } else {
                    Text("قريبًا")
                        .font(AppTheme.Title)
                        .foregroundStyle(AppTheme.titleText)
                        .screenBackground()
                }
            }
            .onChange(of: vm.openRegion) { _, newValue in
                if newValue == nil { vm.regionClosed() }
            }
            .onAppear { checkFinale() }
            .overlay {
                if showFinale {
                    FinaleView {
                        store.markFinaleShown()
                        withAnimation { showFinale = false }
                    }
                    .transition(.opacity)
                }
            }
        }
        .preferredColorScheme(.dark)
        .environment(vm)
    }
    
    private func checkFinale() {
        guard totalGalleries > 0,
              store.completed.count >= totalGalleries,
              !store.finaleShown else { return }
        Task {
            try? await Task.sleep(for: .seconds(0.6))
            withAnimation { showFinale = true }
        }
    }
}

#Preview {
    MapView()
        .environment(ProgressStore())
}

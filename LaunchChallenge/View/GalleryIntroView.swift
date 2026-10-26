import SwiftUI

struct GalleryIntroView: View {

    let region: Region

    @StateObject private var viewModel: GalleryViewModel
    @State private var showGallery = false

    private let bannerHeight: CGFloat = 200

    init(region: Region, galleryId: String) {
        self.region = region
        _viewModel = StateObject(wrappedValue: GalleryViewModel(galleryId: galleryId))
    }

    var body: some View {
        VStack(spacing: 0) {

            PatternView(pattern: region.pattern)
                .frame(height: bannerHeight)
                .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 40,
                                                  bottomTrailingRadius: 40))

            Spacer()

            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Text("أهلًا بك في")
                        .font(AppTheme.MainTitle)
                        .foregroundStyle(AppTheme.bodyText)

                    Text(viewModel.gallery?.region ?? "")
                        .font(AppTheme.MainTitle)
                        .foregroundStyle(AppTheme.titleText)
                }
                
                Text("معرض \(viewModel.gallery?.galleryName ?? "")")
                    .font(AppTheme.Title)
                    .foregroundStyle(AppTheme.bodyText)

                Text("بانتظارك \(viewModel.stations.count) محطات ولغز غامض")
                    .font(AppTheme.Title)
                    .foregroundStyle(AppTheme.bodyText)
                    .multilineTextAlignment(.leading)

                Button("ابدأ رحلتك") {
                    showGallery = true
                }
                .font(AppTheme.body)
                .foregroundStyle(AppTheme.background)
                .padding(.vertical, 10)
                .padding(.horizontal, 36)
                .background(AppTheme.tabSelected)
                .clipShape(Capsule())
                .contentShape(Capsule())
                .padding(.top, 25)
            }
            .padding(.bottom, 80)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
        }
        .ignoresSafeArea(edges: .top)
        .backgroundDesign(.bottomLeft, width: 140, offset: 60)
        .screenBackground()
        .navigationDestination(isPresented: $showGallery) {
            GalleryView(galleryId: viewModel.gallery?.galleryId ?? "")
        }
    }
}

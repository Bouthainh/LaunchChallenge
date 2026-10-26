import SwiftUI

struct MapView: View {
    @State private var vm = MapViewModel()

    var body: some View {
        @Bindable var vm = vm

        NavigationStack {
            VStack(alignment: .leading, spacing: 8) {

                Text("المملكة العربية السعودية")
                    .font(AppTheme.MainTitle)
                    .foregroundStyle(AppTheme.titleText)

                Text("خريطة الزخارف التراثية")
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

                    Text("اختر منطقة لكي تبدأ رحلتك الشيقة في معارض الزخارف السعودية")
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
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MapView()
}

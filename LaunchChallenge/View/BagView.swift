import SwiftUI

struct BagView: View {
    @Environment(ProgressStore.self) private var store

    private let content = ContentLoader.load()
    private var rewards: [RewardModel] { content?.rewards ?? [] }
    private var galleries: [GalleryModel] { content?.galleries ?? [] }
    private var progress: Double {
        galleries.isEmpty ? 0 : Double(store.completed.count) / Double(galleries.count)
    }

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 14), count: 3)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 80) {
                collectionSection
                progressSection
            }
            .padding(.horizontal, 24)
            .padding(.top, 80)
            .padding(.bottom, 30)
        }
        .backgroundDesign(.bottomLeft, width: 160, offset: 50)
        .screenBackground()
        .onDisappear {
            for reward in rewards where store.state(of: reward) == .new {
                store.markSeen(reward.rewardId)
            }
        }
    }

    private var collectionSection: some View {
        VStack(alignment: .leading, spacing: 30) {
            SectionTitle(text: "حصـاد الرحلـة")

            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(rewards) { reward in
                    let state = store.state(of: reward)
                    Button {
                        if state == .new { store.markSeen(reward.rewardId) }
                    } label: {
                        ItemCell(imageName: reward.image, state: state)
                    }
                    .buttonStyle(.plain)
                    .disabled(state == .locked)
                }
            }
            .padding(22)
            .background(RoundedRectangle(cornerRadius: 30, style: .continuous).fill(AppTheme.containerFill))
            .padding(10)
            .overlay(RoundedRectangle(cornerRadius: 40, style: .continuous)
                .stroke(AppTheme.titleText, lineWidth: 1.5))
        }
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .firstTextBaseline) {
                SectionTitle(text: "رحلتك بين زخـارف المملكـة")
                Spacer()
                Text("المناطـق \(store.completed.count)/\(galleries.count)")
                    .font(.custom(AppTheme.displayFontName, size: 20))
                    .foregroundStyle(AppTheme.bodyText)
            }
            Rectangle().fill(AppTheme.divider).frame(height: 1)
            RegionProgressBar(value: progress)
            Rectangle().fill(AppTheme.divider).frame(height: 1)
            RegionChips(galleries: galleries, completed: store.completed)
        }
    }
}

struct ItemCell: View {
    let imageName: String
    let state: ItemState

    var body: some View {
        ZStack {
            AppTheme.cellFill
            Image(imageName)
                .resizable().scaledToFit().padding(8)
                .blur(radius: state == .locked ? 8 : 0)
                .opacity(state == .locked ? 0.5 : 1)
            if state == .locked {
                Image(systemName: "lock.fill")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.titleText)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
            .stroke(AppTheme.cellBorder, lineWidth: 1))
        .overlay(alignment: .topLeading) {
            if state == .new { NewBadge().offset(x: -6, y: -10) }
        }
        .animation(.easeInOut(duration: 0.3), value: state)
    }
}

struct RegionChips: View {
    let galleries: [GalleryModel]
    let completed: Set<String>

    private var ordered: [GalleryModel] {
        galleries.filter { completed.contains($0.galleryId) }
        + galleries.filter { !completed.contains($0.galleryId) }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(ordered, id: \.galleryId) { gallery in
                    let done = completed.contains(gallery.galleryId)
                    HStack(spacing: 4) {
                        if done { Image(systemName: "checkmark").font(.system(size: 10, weight: .bold)) }
                        Text(gallery.region)
                    }
                    .font(.custom(AppTheme.displayFontName, size: 18))
                    .padding(.horizontal, 22)
                    .frame(height: 32)
                    .foregroundStyle(done ? AppTheme.onChip : AppTheme.bodyText)
                    .background(Capsule().fill(done ? AppTheme.titleText : AppTheme.chipIdle))
                }
            }
        }
    }
}

struct SectionTitle: View {
    let text: String
    var body: some View {
        Text(text)
            .font(AppTheme.Title)
            .foregroundStyle(AppTheme.titleText)
    }
}

struct NewBadge: View {
    var body: some View {
        Text("جديد")
            .font(.custom(AppTheme.displayFontName, size: 12))
            .foregroundStyle(AppTheme.onChip)
            .padding(.horizontal, 8).padding(.vertical, 3)
            .background(Capsule().fill(AppTheme.titleText))
    }
}

struct RegionProgressBar: View {
    let value: Double
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(AppTheme.track)
                Capsule().fill(AppTheme.progressFill)
                    .frame(width: geo.size.width * min(max(value, 0), 1))
            }
        }
        .frame(height: 8)
        .animation(.easeInOut(duration: 0.4), value: value)
    }
}


#Preview {
    BagView()
        .environment(ProgressStore())
}

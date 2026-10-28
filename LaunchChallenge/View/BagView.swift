import SwiftUI

struct BagView: View {
    @Environment(ProgressStore.self) private var store
    private let items = BagItem.sample

    private let cellSize: CGFloat = 76
    private let spacing: CGFloat = 14
    private let perRow = 3

    private var rows: [[BagItem]] {
        stride(from: 0, to: items.count, by: perRow).map {
            Array(items[$0 ..< min($0 + perRow, items.count)])
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                collectionSection
                progressSection
            }
            .padding(.horizontal, 24)
            .padding(.top, 56)      // مساحة لزر الصوت  RootView
            .padding(.bottom, 24)
        }
        .backgroundDesign(.bottomLeft)
        .screenBackground()
    }

    // MARK: - المجموعة
    private var collectionSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionTitle(text: "مجموعتك")

            VStack(spacing: spacing) {
                ForEach(rows.indices, id: \.self) { rowIndex in
                    HStack(spacing: spacing) {
                        ForEach(rows[rowIndex]) { item in
                            let state = store.state(of: item)
                            Button {
                                if state == .new { store.markSeen(item) }
                            } label: {
                                ItemCell(item: item, state: state)
                                    .frame(width: cellSize, height: cellSize)
                            }
                            .buttonStyle(.plain)
                            .disabled(state == .locked)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(22)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(AppTheme.containerFill)
            )
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 40, style: .continuous)
                    .stroke(AppTheme.titleText, lineWidth: 1.5)
            )
        }
    }

    // MARK: - تقدم الأحجية
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                SectionTitle(text: "تقدّم الأحجية")
                Spacer()
                Text("المناطق \(store.completedCount)/\(store.totalRegions)")
                    .font(.custom(AppTheme.displayFontName, size: 15))
                    .foregroundStyle(AppTheme.bodyText)
            }
            Rectangle().fill(AppTheme.divider).frame(height: 1)
            RegionProgressBar(value: store.progress)
            Rectangle().fill(AppTheme.divider).frame(height: 1)
            RegionChips(completed: store.completedRegions)
        }
    }
}

// MARK: - Pieces

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
            .font(.custom(AppTheme.displayFontName, size: 11))
            .foregroundStyle(AppTheme.onChip)
            .padding(.horizontal, 8).padding(.vertical, 3)
            .background(Capsule().fill(AppTheme.titleText))
    }
}

struct ItemCell: View {
    let item: BagItem
    let state: ItemState

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            AppTheme.cellFill
            Image(item.imageName)
                .resizable().scaledToFit().padding(8)
                .blur(radius: state == .locked ? 6 : 0)
                .opacity(state == .locked ? 0.85 : 1)
            if state == .locked {
                Image(systemName: "lock.fill")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(AppTheme.titleText)
                    .padding(7)
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
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
    }

    private var label: String {
        switch state {
        case .locked:    return "\(item.name)، مقفل"
        case .new:       return "\(item.name)، جديد"
        case .collected: return "\(item.name)، تم جمعه"
        }
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
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("التقدم")
        .accessibilityValue("\(Int(value * 100)) بالمئة")
    }
}

struct RegionChips: View {
    let completed: Set<Region>
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Region.allCases) { chip(for: $0) }
            }
        }
    }

    private func chip(for region: Region) -> some View {
        let done = completed.contains(region)
        return HStack(spacing: 4) {
            if done { Image(systemName: "checkmark").font(.system(size: 10, weight: .bold)) }
            Text(region.title)
        }
        .font(.custom(AppTheme.displayFontName, size: 13))
        .padding(.horizontal, 14)
        .frame(height: 32)
        .foregroundStyle(done ? AppTheme.onChip : AppTheme.bodyText)
        .background(Capsule().fill(done ? AppTheme.titleText : AppTheme.chipIdle))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(region.title)، \(done ? "مكتملة" : "غير مكتملة")")
    }
}

#Preview {
    BagView()
        .environment(ProgressStore.preview)
}

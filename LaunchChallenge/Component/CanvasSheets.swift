import SwiftUI

private struct SheetTitle: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.custom(AppTheme.displayFontName, size: 20))
            .foregroundStyle(AppTheme.titleText)
    }
}

struct BagPickerSheet: View {
    let items: [RewardModel]
    let onPick: (RewardModel) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SheetTitle(text: "ملصقاتك")

            if items.isEmpty {
                Text("اجمع الملصقات من المعارض لتستخدمها هنا.")
                    .font(AppTheme.body)
                    .foregroundStyle(AppTheme.bodyText.opacity(0.7))
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(items) { item in
                            Button { onPick(item) } label: {
                                Image(item.image)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(8)
                                    .frame(width: 88, height: 88)
                                    .background(RoundedRectangle(cornerRadius: 12)
                                        .fill(AppTheme.titleHighlight))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(24)
    }
}

struct ColorSheet: View {
    let title: String
    let onPick: (Color) -> Void

    @State private var custom = Color.white
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 14), count: 5)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SheetTitle(text: title)

            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(CanvasPalette.colors.indices, id: \.self) { index in
                    Button { onPick(CanvasPalette.colors[index]) } label: {
                        Circle()
                            .fill(CanvasPalette.colors[index])
                            .frame(width: 44, height: 44)
                            .overlay(Circle().stroke(Color.gray.opacity(0.4), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
            }

            ColorPicker("لون مخصص", selection: Binding(
                get: { custom },
                set: { custom = $0; onPick($0) }))
                .font(AppTheme.body)
                .foregroundStyle(AppTheme.bodyText)

            Spacer()
        }
        .padding(24)
    }
}

struct FontSheet: View {
    let hasText: Bool
    @Binding var style: CanvasFontStyle
    @Binding var size: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SheetTitle(text: "الخط")

            if hasText {
                Picker("النمط", selection: $style) {
                    ForEach(CanvasFontStyle.allCases) { option in
                        Text(option.title).tag(option)
                    }
                }
                .pickerStyle(.segmented)

                HStack {
                    Text("الحجم").font(AppTheme.body).foregroundStyle(AppTheme.bodyText)
                    Slider(value: $size, in: 16...72)
                    Text("\(Int(size))")
                        .monospacedDigit()
                        .foregroundStyle(AppTheme.bodyText)
                        .frame(width: 32, alignment: .trailing)
                }
            } else {
                Text("اختر نصًا على اللوحة أولًا، ثم غيّر خطه.")
                    .font(AppTheme.body)
                    .foregroundStyle(AppTheme.bodyText.opacity(0.7))
            }
            Spacer()
        }
        .padding(24)
    }
}

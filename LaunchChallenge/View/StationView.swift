import SwiftUI

//Displays one station's image, title, and text
struct StationView: View {

    let station: StationModel

    //the interface states:
    @State private var isExpanded = false //whether the text is expanded
    @State private var fullHeight: CGFloat = 0 //stores how tall text
    @State private var limitedHeight: CGFloat = 0 //Stores text when restricted

    //image and lines constants
    private let collapsedLines = 9
    private let imageHeight: CGFloat = 480

    //compute conditions of the text states, to add read more action
    private var isTruncated: Bool { fullHeight > limitedHeight + 1 }
    private var isCollapsed: Bool { isTruncated && !isExpanded }

    //style for title "highlight"
    var highlightedTitle: AttributedString {
        var text = AttributedString(station.stationTitle)
        text.backgroundColor = AppTheme.titleHighlight
        return text
    }

    //body text style and appearence
    private var bodyText: some View {
        Text(station.text)
            .font(AppTheme.body)
            .foregroundStyle(AppTheme.bodyText)
            .lineSpacing(6)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    //text measre function:
    private func measure(lines: Int?, store: @escaping (CGFloat) -> Void) -> some View {
        bodyText
            .lineLimit(lines)
            .fixedSize(horizontal: false, vertical: true)
            .hidden()
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onChange(of: geo.size.height, initial: true) { _, newHeight in
                            store(newHeight)
                        }
                }
            )
    }

    //UI:
    var body: some View {
        ZStack(alignment: .top) {

            // Layer 1: the image, always the same size
            Image(station.media)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: imageHeight)
                .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 40,
                                                  bottomTrailingRadius: 40))

            // Layer 2: the text panel
            VStack(alignment: .leading, spacing: 12) {

                Text(highlightedTitle)
                    .font(AppTheme.Title)
                    .foregroundStyle(AppTheme.titleText)
                    .frame(maxWidth: .infinity, alignment: .leading)

                bodyText
                    .lineLimit(isExpanded ? nil : collapsedLines)
                    .mask(
                        LinearGradient(
                            stops: [
                                .init(color: .black, location: 0),
                                .init(color: .black, location: 0.5),
                                .init(color: isCollapsed ? .clear : .black, location: 1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .background(
                        ZStack {
                            measure(lines: collapsedLines) { limitedHeight = $0 }
                            measure(lines: nil) { fullHeight = $0 }
                        }
                    )

                if isTruncated {
                    Button(isExpanded ? "عرض أقل" : "اقرأ المزيد") {
                        withAnimation(.easeInOut) {
                            isExpanded.toggle()
                        }
                    }
                    .font(AppTheme.body)
                    .foregroundStyle(AppTheme.tabSelected)
                }
            } //the effect of expand the text to red more
            .padding(20)
            .padding(.top, isExpanded ? 50 : 0)
            .background(alignment: .top) {
                LinearGradient(
                    colors: [.clear, AppTheme.background, AppTheme.background],
                    startPoint: .top,
                    endPoint: UnitPoint(x: 0.5, y: 0.25)
                )
                .opacity(isExpanded ? 1.0 : 0.0)
            }
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: isExpanded ? .bottom : .top)
            .padding(.top, isExpanded ? 0 : imageHeight)
        }
        .ignoresSafeArea(edges: .top)
        .screenBackground()
    }
}

#Preview {
    StationView(station: ContentLoader.load()!.galleries[0].stations[3])
        .environment(\.layoutDirection, .rightToLeft)
}

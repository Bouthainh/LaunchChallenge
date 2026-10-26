import SwiftUI

enum DesignPlacement {
    case topRight
    case bottomLeft
}

struct BackgroundDesign: ViewModifier {

    let placement: DesignPlacement
    let width: CGFloat
    let offset: CGFloat

    @Environment(\.layoutDirection) private var direction

    private var alignment: Alignment {
        let rightSide: Alignment = direction == .rightToLeft ? .topLeading : .topTrailing
        let leftSide: Alignment = direction == .rightToLeft ? .bottomTrailing : .bottomLeading
        return placement == .topRight ? rightSide : leftSide
    }

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(alignment: alignment) {
                Image("BackgroundDesign")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width)
                    .padding(placement == .topRight ? .top : .bottom, offset)
                    .allowsHitTesting(false)
            }
    }
}

extension View {
    func backgroundDesign(_ placement: DesignPlacement,
                          width: CGFloat = 220,
                          offset: CGFloat = 0) -> some View {
        modifier(BackgroundDesign(placement: placement, width: width, offset: offset))
    }
}

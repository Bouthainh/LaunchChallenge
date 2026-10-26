import SwiftUI

struct StationProgressBar: View {

    let total: Int
    let current: Int

    var body: some View {
        VStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index <= current ? Color("BlueGreen") : Color.white.opacity(0.35))
                    .frame(width: 7, height: 60)
            }
        }
        .animation(.easeInOut, value: current)
    }
}

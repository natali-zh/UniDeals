import SwiftUI

struct FeaturedPageIndicator: View {

    let count: Int
    let currentIndex: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { i in
                Capsule()
                    .fill(i == currentIndex ? Color.colorPrimary : Color.gray300)
                    .frame(width: i == currentIndex ? 20 : 6, height: 6)
                    .animation(.easeInOut(duration: 0.2), value: currentIndex)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

import SwiftUI

struct SaveButton: View {
    let isSaved: Bool
    var backgroundOpacity: Double = 0.25
    var action: () -> Void

    @State private var scale: CGFloat = 1

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
                scale = 1.3
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    scale = 1
                }
            }
            action()
        } label: {
            Image(systemName: isSaved ? "heart.fill" : "heart")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSaved ? .red : .white)
                .padding(10)
                .background(Circle().fill(Color.black.opacity(backgroundOpacity)))
                .scaleEffect(scale)
        }
    }
}

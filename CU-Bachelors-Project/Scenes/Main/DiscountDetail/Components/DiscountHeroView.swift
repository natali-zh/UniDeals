import SwiftUI

struct DiscountHeroView: View {

    let discount: Discount
    let isSaved: Bool
    let onBack: () -> Void
    let onToggleSave: () -> Void

    var body: some View {
        GeometryReader { geo in
            let stretch = max(0, geo.frame(in: .global).minY)
            let totalHeight = 280 + stretch

            ZStack(alignment: .bottom) {
                heroImage(width: geo.size.width, height: totalHeight)
                LinearGradient(
                    colors: [.clear, .black.opacity(0.5)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .frame(maxWidth: .infinity, maxHeight: totalHeight)
            }
            .overlay(alignment: .top) {
                HStack {
                    navButton(icon: "chevron.left", action: onBack)
                    Spacer()
                    navButton(
                        icon: isSaved ? "heart.fill" : "heart",
                        tint: isSaved ? .red : .primary,
                        action: onToggleSave
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 56)
            }
            .frame(width: geo.size.width, height: totalHeight)
            .offset(y: -stretch)
        }
        .frame(height: 280)
    }

    @ViewBuilder
    private func heroImage(width: CGFloat, height: CGFloat) -> some View {
        if let urlStr = discount.imageUrl, let url = URL(string: urlStr) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                        .frame(width: width, height: height)
                        .clipped()
                default:
                    placeholder.frame(width: width, height: height)
                }
            }
        } else {
            placeholder.frame(width: width, height: height)
        }
    }

    private var placeholder: some View {
        Color.gray100.overlay(
            Image(systemName: "tag.fill")
                .font(.system(size: 48))
                .foregroundColor(Color.colorPrimary.opacity(0.15))
        )
    }

    private func navButton(icon: String, tint: Color = .primary, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(tint)
                .heroNavButton()
        }
    }
}

import SwiftUI

struct PartnerHeroView: View {

    let partner: Partner
    let onBack: () -> Void

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

                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.gray900)
                            .heroNavButton()
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 56)
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .frame(width: geo.size.width, height: totalHeight)
            .offset(y: -stretch)
        }
        .frame(height: 280)
    }

    @ViewBuilder
    private func heroImage(width: CGFloat, height: CGFloat) -> some View {
        if let logoUrl = partner.logoUrl, let url = URL(string: logoUrl) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                        .frame(width: width, height: height)
                        .clipped()
                default:
                    placeholder(width: width, height: height)
                }
            }
        } else {
            placeholder(width: width, height: height)
        }
    }

    private func placeholder(width: CGFloat, height: CGFloat) -> some View {
        Color.gray100
            .frame(width: width, height: height)
            .overlay(
                Image(systemName: "storefront")
                    .font(.system(size: 48))
                    .foregroundColor(Color.gray500.opacity(0.3))
            )
    }
}

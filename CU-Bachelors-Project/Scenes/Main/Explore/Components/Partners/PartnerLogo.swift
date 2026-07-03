import SwiftUI

struct PartnerLogo: View {

    let logoUrl: String?

    var body: some View {
        Group {
            if let logoUrl, let url = URL(string: logoUrl), !logoUrl.isEmpty {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(width: 56, height: 56)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.gray300, lineWidth: 0.5))
    }

    private var placeholder: some View {
        Color.gray100.overlay(
            Image(systemName: "storefront")
                .font(.system(size: 22))
                .foregroundColor(Color.gray500.opacity(0.4))
        )
    }
}

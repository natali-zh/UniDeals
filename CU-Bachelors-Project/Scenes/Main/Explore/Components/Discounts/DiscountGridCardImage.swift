import SwiftUI

struct DiscountGridCardImage: View {

    let imageUrl: String?

    var body: some View {
        Color.gray100
            .overlay(RemoteImage(url: imageUrl, placeholder: Image(systemName: "photo")))
            .clipShape(.rect(topLeadingRadius: 14, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 14))
    }
}

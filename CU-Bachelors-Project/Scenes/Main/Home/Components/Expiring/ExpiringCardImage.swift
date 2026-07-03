import SwiftUI

struct ExpiringCardImage: View {

    let imageUrl: String?

    var body: some View {
        Color.gray100
            .overlay(RemoteImage(url: imageUrl, placeholder: Image(systemName: "photo")))
            .clipShape(.rect(topLeadingRadius: 16, bottomLeadingRadius: 16, bottomTrailingRadius: 0, topTrailingRadius: 0))
    }
}

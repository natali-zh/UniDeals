import SwiftUI

struct NearbyCardImage: View {

    let imageUrl: String?

    var body: some View {
        Color.gray100
            .frame(height: 130)
            .overlay(RemoteImage(url: imageUrl, placeholder: Image(systemName: "photo")))
            .clipShape(.rect(topLeadingRadius: 16, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 16))
    }
}

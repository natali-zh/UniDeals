import SwiftUI

struct FeaturedCardImage: View {

    let imageUrl: String?

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.gray100)
            .frame(height: 210)
            .overlay(RemoteImage(url: imageUrl, placeholder: Image(systemName: "photo")))
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

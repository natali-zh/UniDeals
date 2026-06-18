import SwiftUI
import Kingfisher

struct RemoteImage: View {
    let url: String?
    var contentMode: SwiftUI.ContentMode = .fill
    var placeholder: Image = Image(systemName: "photo")

    var body: some View {
        if let url, let parsed = URL(string: url), !url.isEmpty {
            KFImage(parsed)
                .placeholder { placeholderView }
                .fade(duration: 0)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } else {
            placeholderView
        }
    }

    private var placeholderView: some View {
        ZStack {
            Color.gray.opacity(0.15)
            placeholder
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray.opacity(0.4))
        }
    }
}


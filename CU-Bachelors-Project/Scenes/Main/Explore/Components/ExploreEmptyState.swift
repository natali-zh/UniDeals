import SwiftUI

struct ExploreEmptyState: View {

    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(.gray300)
            Text(message)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.gray500)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

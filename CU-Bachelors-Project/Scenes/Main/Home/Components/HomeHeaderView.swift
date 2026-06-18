import SwiftUI

struct HomeHeaderView: View {

    let userName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("გამარჯობა, \(userName)")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)

            Text("იპოვე შენი შეთავაზება")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            Color.white.ignoresSafeArea(edges: .top)
        )
    }
}

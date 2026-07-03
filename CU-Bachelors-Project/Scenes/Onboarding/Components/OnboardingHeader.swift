import SwiftUI

struct OnboardingHeader: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.colorPrimary.opacity(0.1))
                    .frame(width: 72, height: 72)
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(.colorPrimary)
            }

            VStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.gray900)

                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray500)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
    }
}

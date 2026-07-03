import SwiftUI

struct SavedDiscountsEmptyState: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.gray300)
            Text("შენახული შეთავაზება არ გაქვს")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray500)
            Text("შენი ფავორიტი შეთავაზებები აქ გამოჩნდება")
                .font(.system(size: 13))
                .foregroundColor(.gray300)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

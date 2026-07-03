import SwiftUI

struct DiscountBottomCTA: View {

    let onViewOnMap: () -> Void
    let onUseDiscount: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onViewOnMap) {
                HStack(spacing: 6) {
                    Image(systemName: "map").font(.system(size: 14, weight: .medium))
                    Text("რუკაზე ნახვა").font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(.gray900)
                .secondaryActionButton()
            }

            Button(action: onUseDiscount) {
                HStack(spacing: 6) {
                    Image(systemName: "qrcode").font(.system(size: 14, weight: .medium))
                    Text("გამოყენება").font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(.white)
                .primaryActionButton()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

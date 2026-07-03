import SwiftUI

struct PartnerOffersSection: View {

    let offers: [Discount]
    let isLoading: Bool
    let distanceText: (Discount) -> String
    let onOfferTapped: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header

            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else if offers.isEmpty {
                Text("ამ პარტნიორს ამჟამად შეთავაზებები არ აქვს")
                    .font(.system(size: 14))
                    .foregroundColor(.gray500)
                    .padding(.vertical, 12)
            } else {
                VStack(spacing: 10) {
                    ForEach(offers) { offer in
                        OfferRow(
                            offer: offer,
                            distanceText: distanceText(offer),
                            onTap: { onOfferTapped(offer.id ?? "") }
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }

    private var header: some View {
        HStack(spacing: 8) {
            Text("ხელმისაწვდომი შეთავაზებები")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.gray900)

            if !offers.isEmpty {
                Text("\(offers.count)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.colorPrimary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.colorPrimary.opacity(0.1))
                    .clipShape(Capsule())
            }
        }
    }
}

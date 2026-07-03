import SwiftUI

struct PartnersListView: View {

    let partners: [Partner]
    let offerCount: (Partner) -> Int
    let onTap: (String) -> Void

    var body: some View {
        VStack(spacing: 10) {
            ForEach(partners) { partner in
                PartnerRow(partner: partner, offerCount: offerCount(partner))
                    .onTapGesture { onTap(partner.id ?? "") }
            }
        }
        .padding(.horizontal, 16)
    }
}

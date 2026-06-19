import CoreLocation
import SwiftUI

struct PartnerDetailView: View {

    @StateObject private var viewModel: PartnerDetailViewModel

    init(viewModel: PartnerDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    heroSection
                    contentCard
                }
            }
            .ignoresSafeArea(edges: .top)

            mapButton
                .stickyFooter()
        }
        .navigationBarHidden(true)
        .background(Color.white)
        .task { await viewModel.loadOffers() }
    }

    // MARK: - Hero

    private var heroSection: some View {
        GeometryReader { geo in
            let stretch = max(0, geo.frame(in: .global).minY)
            let totalHeight = 280 + stretch

            ZStack(alignment: .bottom) {
                // Image stretches to fill pull-down gap
                if let logoUrl = viewModel.partner.logoUrl, let url = URL(string: logoUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().aspectRatio(contentMode: .fill)
                                .frame(width: geo.size.width, height: totalHeight)
                                .clipped()
                        default:
                            placeholderView(width: geo.size.width, height: totalHeight)
                        }
                    }
                } else {
                    placeholderView(width: geo.size.width, height: totalHeight)
                }

                LinearGradient(
                    colors: [.clear, .black.opacity(0.5)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .frame(maxWidth: .infinity, maxHeight: totalHeight)

                HStack {
                    Button { viewModel.onBack?() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.gray900)
                            .heroNavButton()
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 56)
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .frame(width: geo.size.width, height: totalHeight)
            .offset(y: -stretch)
        }
        .frame(height: 280)
    }

    private func placeholderView(width: CGFloat, height: CGFloat = 280) -> some View {
        Color.gray100
            .frame(width: width, height: height)
            .overlay(
                Image(systemName: "storefront")
                    .font(.system(size: 48))
                    .foregroundColor(Color.gray500.opacity(0.3))
            )
    }

    // MARK: - Content card

    private var contentCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Partner name + address
            HStack(spacing: 14) {
                partnerLogo

                VStack(alignment: .leading, spacing: 3) {
                    Text(viewModel.partner.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.gray900)

                    HStack(spacing: 4) {
                        Image(systemName: "location.circle")
                            .font(.system(size: 12))
                            .foregroundColor(.gray500)
                        Text(viewModel.partner.address)
                            .font(.system(size: 12))
                            .foregroundColor(.gray500)
                            .lineLimit(1)
                    }
                    .padding(.top, 2)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 12)

            // Info row
            infoSection

            // About
            VStack(alignment: .leading, spacing: 8) {
                Text("კომპანიის შესახებ")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.gray900)

                Text(viewModel.partner.description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray500)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)

            Divider().padding(.horizontal, 20)

            // Available offers
            offersSection

            Color.clear.frame(height: 90)
        }
        .background(Color.white)
        .clipShape(.rect(topLeadingRadius: 24, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 24))
        .padding(.top, -24)
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            let hasPhone = viewModel.partner.phone != nil
            let hasWebsite = viewModel.partner.website != nil

            if hasPhone || hasWebsite {
                HStack(spacing: 12) {
                    if let phone = viewModel.partner.phone {
                        actionButton(icon: "phone.fill", title: "დარეკვა") {
                            if let url = URL(string: "tel://\(phone.replacingOccurrences(of: " ", with: ""))") {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                    if let website = viewModel.partner.website {
                        actionButton(icon: "globe", title: "ვებსაიტი") {
                            if let url = URL(string: website) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }

            Divider().padding(.horizontal, 20)
        }
        .padding(.top, 16)
    }

    private func actionButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.colorPrimary)
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.colorPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.colorPrimary.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    private var partnerLogo: some View {
        Group {
            if let logoUrl = viewModel.partner.logoUrl, let url = URL(string: logoUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    default:
                        Color.gray100
                    }
                }
            } else {
                Color.gray100
            }
        }
        .frame(width: 56, height: 56)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.gray300, lineWidth: 0.5))
    }

    // MARK: - Offers section

    private var offersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text("ხელმისაწვდომი შეთავაზებები")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.gray900)

                if !viewModel.offers.isEmpty {
                    Text("\(viewModel.offers.count)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.colorPrimary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.colorPrimary.opacity(0.1))
                        .clipShape(Capsule())
                }
            }

            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else if viewModel.offers.isEmpty {
                Text("ამ პარტნიორს ამჟამად შეთავაზებები არ აქვს")
                    .font(.system(size: 14))
                    .foregroundColor(.gray500)
                    .padding(.vertical, 12)
            } else {
                VStack(spacing: 10) {
                    ForEach(viewModel.offers) { offer in
                        OfferRow(offer: offer) {
                            viewModel.onOfferTapped?(offer.id ?? "")
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }

    // MARK: - Map button

    private var mapButton: some View {
        let firstOffer = viewModel.offers.first
        return Button {
            if let offer = firstOffer { viewModel.onViewOnMap?(offer) }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "map").font(.system(size: 15, weight: .medium))
                Text("რუკაზე ნახვა").font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(firstOffer == nil ? .gray500 : .white)
            .primaryActionButton()
        }
        .disabled(firstOffer == nil || viewModel.isLoading)
        .opacity(firstOffer == nil ? 0.5 : 1)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

// MARK: - Offer row

private struct OfferRow: View {
    let offer: Discount
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Thumbnail
                Group {
                    if let urlStr = offer.imageUrl, let url = URL(string: urlStr) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable().aspectRatio(contentMode: .fill)
                            default:
                                Color.gray100
                            }
                        }
                    } else {
                        Color.gray100
                    }
                }
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    Text(offer.label)
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.colorPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .padding(6),
                    alignment: .topLeading
                )

                // Info
                VStack(alignment: .leading, spacing: 5) {
                    Text(offer.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray900)
                        .lineLimit(2)

                    HStack(spacing: 10) {
                        Label(liveDistanceText(for: offer), systemImage: "location.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.gray500)

                        Label(DiscountFormatter.daysLeftText(for: offer.endDate), systemImage: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(DiscountFormatter.daysLeftColor(for: offer.endDate))
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray500)
            }
            .padding(12)
            .background(Color(red: 0.97, green: 0.97, blue: 0.98))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    private func liveDistanceText(for discount: Discount) -> String {
        if let userCoord = LocationManager.shared.userLocation {
            let userLoc = CLLocation(latitude: userCoord.latitude, longitude: userCoord.longitude)
            let discountLoc = CLLocation(latitude: discount.latitude, longitude: discount.longitude)
            let km = userLoc.distance(from: discountLoc) / 1000.0
            return DiscountFormatter.distanceText(km)
        }
        return DiscountFormatter.distanceText(discount.distanceKm)
    }

}

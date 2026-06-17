//
//  DiscountDetailView.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 17.06.26.
//

import SwiftUI

struct DiscountDetailView: View {

    @StateObject private var viewModel: DiscountDetailViewModel

    init(discount: Discount) {
        _viewModel = StateObject(wrappedValue: DiscountDetailViewModel(discount: discount))
    }

    init(viewModel: DiscountDetailViewModel) {
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

            bottomButtons
                .stickyFooter()
        }
        .navigationBarHidden(true)
        .background(Color.white)
        .task { await viewModel.loadPartner() }
    }

    // MARK: - Hero

    private var heroSection: some View {
        GeometryReader { geo in
            let stretch = max(0, geo.frame(in: .global).minY)
            let totalHeight = 280 + stretch

            ZStack(alignment: .bottom) {
                // Image stretches to fill pull-down gap
                if let urlStr = viewModel.discount.imageUrl, let url = URL(string: urlStr) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().aspectRatio(contentMode: .fill)
                                .frame(width: geo.size.width, height: totalHeight)
                                .clipped()
                        default:
                            Color.gray100.frame(width: geo.size.width, height: totalHeight)
                        }
                    }
                } else {
                    Color.gray100.frame(width: geo.size.width, height: totalHeight)
                }

                LinearGradient(
                    colors: [.clear, .black.opacity(0.45)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .frame(height: totalHeight)
                .frame(maxWidth: .infinity)

                Text(viewModel.discount.label)
                    .badgeStyle()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 36)

                HStack {
                    Button { viewModel.onBack?() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.gray900)
                            .heroNavButton()
                    }
                    Spacer()
                    Button { viewModel.toggleSave() } label: {
                        Image(systemName: viewModel.isSaved ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(viewModel.isSaved ? .colorPrimary : .gray900)
                            .heroNavButton()
                    }
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

    // MARK: - Content card

    private var contentCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            storeRow
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 20)

            Divider().padding(.horizontal, 20)

            VStack(alignment: .leading, spacing: 16) {
                // Title + info pills
                VStack(alignment: .leading, spacing: 10) {
                    Text(viewModel.discount.title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.gray900)

                    infoPills
                }

                Divider()

                aboutSection

                if !viewModel.isExpired {
                    expiryBanner
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)

            Color.clear.frame(height: 90)
        }
        .background(Color.white)
        .clipShape(.rect(topLeadingRadius: 24, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 24))
        .padding(.top, -24)
    }

    // MARK: - Store row

    private var storeRow: some View {
        HStack(spacing: 12) {
            partnerLogo
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray300, lineWidth: 0.5))

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.discount.storeName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.gray900)
                Text(viewModel.partner?.address ?? viewModel.discount.storeAddress)
                    .font(.system(size: 12))
                    .foregroundColor(.gray500)
                    .lineLimit(1)
            }
        }
    }

    @ViewBuilder
    private var partnerLogo: some View {
        if let logoUrl = viewModel.partner?.logoUrl, let url = URL(string: logoUrl) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                default:
                    placeholderLogo
                }
            }
        } else {
            placeholderLogo
        }
    }

    private var placeholderLogo: some View {
        Color.gray100.overlay(
            Image(systemName: "storefront")
                .font(.system(size: 18))
                .foregroundColor(Color.gray500.opacity(0.4))
        )
    }

    // MARK: - Info pills

    private var infoPills: some View {
        HStack(spacing: 10) {
            InfoPill(
                icon: "location.fill",
                iconColor: .colorPrimary,
                text: viewModel.distanceText
            )
            InfoPill(
                icon: "clock",
                iconColor: viewModel.daysLeftIsUrgent ? .red : .green,
                text: viewModel.daysLeftText
            )
        }
    }

    // MARK: - About section

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("შეთავაზების შესახებ")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.gray900)

            Text(viewModel.discount.description)
                .font(.system(size: 14))
                .foregroundColor(.gray500)
                .lineSpacing(4)
        }
    }

    // MARK: - Expiry banner

    private var expiryBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: "calendar")
                .font(.system(size: 14))
                .foregroundColor(.orange)

            VStack(alignment: .leading, spacing: 2) {
                Text("იწურება \(viewModel.formattedEndDate)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.orange)
                if viewModel.daysLeftIsUrgent {
                    Text("ძალიან მალე იწურება. არ გაუშვა!")
                        .font(.system(size: 11))
                        .foregroundColor(.orange.opacity(0.8))
                }
            }

            Spacer()
        }
        .padding(14)
        .background(Color.orange.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Bottom buttons

    private var bottomButtons: some View {
        HStack(spacing: 12) {
            Button { viewModel.onViewOnMap?() } label: {
                HStack(spacing: 6) {
                    Image(systemName: "map").font(.system(size: 14, weight: .medium))
                    Text("რუკაზე ნახვა").font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(.gray900)
                .secondaryActionButton()
            }

            Button { viewModel.onUseOffer?() } label: {
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

// MARK: - Info Pill

private struct InfoPill: View {
    let icon: String
    let iconColor: Color
    let text: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(iconColor)
            Text(text)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray700)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(Color(red: 0.97, green: 0.97, blue: 0.98))
        .clipShape(Capsule())
    }
}

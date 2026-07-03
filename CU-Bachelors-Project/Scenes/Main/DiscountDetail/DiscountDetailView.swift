import SwiftUI

struct DiscountDetailView: View {

    @StateObject private var viewModel: DiscountDetailViewModel
    @State private var showCard = false

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
                    contentSheet
                }
            }
            .ignoresSafeArea(edges: .top)

            bottomCTA
                .stickyFooter()
        }
        .navigationBarHidden(true)
        .background(Color(.secondarySystemGroupedBackground))
        .task { await viewModel.loadPartner() }
        .sheet(isPresented: $showCard) {
            CardView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Hero (identical pattern to PartnerDetailView)

    private var heroSection: some View {
        GeometryReader { geo in
            let stretch = max(0, geo.frame(in: .global).minY)
            let totalHeight = 280 + stretch

            ZStack(alignment: .bottom) {
                heroImage(width: geo.size.width, height: totalHeight)

                LinearGradient(
                    colors: [.clear, .black.opacity(0.5)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .frame(maxWidth: .infinity, maxHeight: totalHeight)
            }
            .overlay(alignment: .top) {
                HStack {
                    blurNavButton(icon: "chevron.left") { viewModel.onBack?() }
                    Spacer()
                    blurNavButton(
                        icon: viewModel.isSaved ? "heart.fill" : "heart",
                        tint: viewModel.isSaved ? .red : .primary
                    ) { viewModel.toggleSave() }
                }
                .padding(.horizontal, 20)
                .padding(.top, 56)
            }
            .frame(width: geo.size.width, height: totalHeight)
            .offset(y: -stretch)
        }
        .frame(height: 280)
    }

    @ViewBuilder
    private func heroImage(width: CGFloat, height: CGFloat) -> some View {
        if let urlStr = viewModel.discount.imageUrl, let url = URL(string: urlStr) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                        .frame(width: width, height: height)
                        .clipped()
                default:
                    heroBg.frame(width: width, height: height)
                }
            }
        } else {
            heroBg.frame(width: width, height: height)
        }
    }

    private var heroBg: some View {
        Color.gray100.overlay(
            Image(systemName: "tag.fill")
                .font(.system(size: 48))
                .foregroundColor(Color.colorPrimary.opacity(0.15))
        )
    }

    private func blurNavButton(icon: String, tint: Color = .primary, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(tint)
                .heroNavButton()
        }
    }

    // MARK: - Content sheet (same white sheet + divider pattern as PartnerDetailView)

    private var contentSheet: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleBlock
            Divider().padding(.horizontal, 20)
            aboutSection
            Divider().padding(.horizontal, 20)
            validitySection
            Divider().padding(.horizontal, 20)
            merchantSection
            Color.clear.frame(height: 90)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(topLeadingRadius: 24, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 24))
        .padding(.top, -24)
    }

    // MARK: - Title block

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.discount.title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.gray900)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 16) {
                Label(viewModel.distanceText, systemImage: "location.fill")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray500)
                Label(viewModel.daysLeftText, systemImage: "clock")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(viewModel.daysLeftIsUrgent ? .red : .gray500)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 16)
    }

    // MARK: - Merchant section

    private var merchantSection: some View {
        sectionBlock(title: "პარტნიორი") {
            Button {
                viewModel.onPartnerTapped?(viewModel.partner?.id ?? viewModel.discount.storeId)
            } label: {
                HStack(spacing: 12) {
                    partnerLogo

                    VStack(alignment: .leading, spacing: 3) {
                        Text(viewModel.discount.storeName)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.gray900)

                        HStack(spacing: 4) {
                            Image(systemName: "location.circle")
                                .font(.system(size: 11))
                                .foregroundColor(.gray500)
                            Text(viewModel.partner?.address ?? viewModel.discount.storeAddress)
                                .font(.system(size: 12))
                                .foregroundColor(.gray500)
                                .lineLimit(1)
                        }
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.gray500)
                }
            }
            .buttonStyle(.plain)
        }
    }

    private var partnerLogo: some View {
        Group {
            if let logoUrl = viewModel.partner?.logoUrl, let url = URL(string: logoUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    default:
                        Color.gray100
                    }
                }
            } else {
                Color.gray100.overlay(
                    Image(systemName: "storefront")
                        .font(.system(size: 20))
                        .foregroundColor(Color.gray500.opacity(0.4))
                )
            }
        }
        .frame(width: 56, height: 56)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.gray300, lineWidth: 0.5))
    }

    // MARK: - About section

    private var aboutSection: some View {
        sectionBlock(title: "შეთავაზების შესახებ") {
            Text(viewModel.discount.description)
                .font(.system(size: 14))
                .foregroundColor(.gray500)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Validity section

    private var validitySection: some View {
        sectionBlock(title: "მოქმედების ვადა") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 24) {
                    dateColumn(label: "დაწყება", value: DiscountFormatter.formattedDate(viewModel.discount.startDate))
                    Divider().frame(height: 32)
                    dateColumn(label: "დასრულება", value: viewModel.formattedEndDate)
                    Spacer()
                }
            }
        }
    }

    private func dateColumn(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.gray500)
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray900)
        }
    }

    // MARK: - Shared layout helper

    private func sectionBlock<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.gray900)
            content()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }

    // MARK: - Bottom CTA

    private var bottomCTA: some View {
        HStack(spacing: 12) {
            Button { viewModel.onViewOnMap?(viewModel.discount) } label: {
                HStack(spacing: 6) {
                    Image(systemName: "map").font(.system(size: 14, weight: .medium))
                    Text("რუკაზე ნახვა").font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(.gray900)
                .secondaryActionButton()
            }

            Button { showCard = true } label: {
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

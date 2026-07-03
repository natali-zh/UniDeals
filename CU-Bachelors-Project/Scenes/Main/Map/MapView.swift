import SwiftUI
import MapKit

struct MapView: View {

    @State private var viewModel: MapViewModel

    init(viewModel: MapViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.6941, longitude: 44.8337),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ))

    var body: some View {
        ZStack(alignment: .top) {
            ZStack(alignment: .bottom) {
            Map(position: $position) {
                UserAnnotation()
                ForEach(viewModel.filteredDiscounts) { discount in
                    if let id = discount.id {
                        Annotation("", coordinate: CLLocationCoordinate2D(
                            latitude: discount.latitude,
                            longitude: discount.longitude
                        ), anchor: .bottom) {
                            DiscountPin(
                                discount: discount,
                                isSelected: viewModel.selectedDiscount?.id == id
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                    viewModel.select(discount: discount)
                                }
                            }
                        }
                    }
                }
            }
            .mapControls {
                MapUserLocationButton()
            }

            if let discount = viewModel.selectedDiscount {
                discountCard(discount)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 8)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }
        } // inner ZStack

            categoryChips
                .zIndex(2)
        } // outer ZStack
        .navigationTitle("აღმოაჩინე რუკაზე")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
        .onAppear { LocationManager.shared.requestPermission() }
        .onChange(of: LocationManager.shared.locationUpdateCount) { _, _ in
            guard let location = LocationManager.shared.userLocation else { return }
            withAnimation {
                position = .region(MKCoordinateRegion(
                    center: location,
                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                ))
            }
        }
        .onChange(of: viewModel.pendingDiscount?.id) { _, id in
            guard id != nil, let discount = viewModel.pendingDiscount else { return }
            withAnimation {
                position = .region(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: discount.latitude, longitude: discount.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                ))
            }
            viewModel.pendingDiscount = nil
        }
    }

    // MARK: - Category chips

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.categories) { category in
                    MapCategoryChip(
                        category: category,
                        isSelected: viewModel.selectedCategoryId == category.id
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            viewModel.selectCategory(category.id)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(.ultraThinMaterial)
    }

    // MARK: - Discount card

    private func discountCard(_ discount: Discount) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                discountImage(discount)

                VStack(alignment: .leading, spacing: 3) {
                    Text(discount.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.gray900)
                        .lineLimit(1)
                    Text(discount.storeName)
                        .font(.system(size: 13))
                        .foregroundColor(.gray500)
                    HStack(spacing: 10) {
                        Label(DiscountFormatter.distanceText(discount.distanceKm), systemImage: "location")
                        Label(DiscountFormatter.daysLeftText(for: discount.endDate), systemImage: "clock")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(.gray500)
                    .labelStyle(.titleAndIcon)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            viewModel.clearSelection()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray500)
                            .frame(width: 28, height: 28)
                            .background(Color.gray100)
                            .clipShape(Circle())
                    }

                    Text(discount.label)
                        .badgeStyle()
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            Button {
                viewModel.onViewOffer?(discount)
            } label: {
                Text("შეთავაზების ნახვა")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .primaryActionButton(verticalPadding: 14)
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 8)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: -4)
    }

    @ViewBuilder
    private func discountImage(_ discount: Discount) -> some View {
        if let urlStr = discount.imageUrl, let url = URL(string: urlStr) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                default:
                    placeholderImage
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
            placeholderImage
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var placeholderImage: some View {
        Color.gray100.overlay(
            Image(systemName: "storefront")
                .font(.system(size: 22))
                .foregroundColor(Color.gray500.opacity(0.4))
        )
    }
}

// MARK: - Discount Pin

private struct DiscountPin: View {

    let discount: Discount
    let isSelected: Bool

    var pinColor: Color {
        discount.discountType == "freeItem" ? .orange : .colorPrimary
    }

    var body: some View {
        VStack(spacing: 3) {
            if isSelected {
                Text(discount.label)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(pinColor)
                    .clipShape(Capsule())
                    .shadow(color: pinColor.opacity(0.4), radius: 4, x: 0, y: 2)
            }

            ZStack {
                Circle()
                    .fill(isSelected ? pinColor : Color(.secondarySystemGroupedBackground))
                    .frame(width: isSelected ? 42 : 34, height: isSelected ? 42 : 34)
                    .shadow(color: .black.opacity(0.18), radius: 4, x: 0, y: 2)

                Image(systemName: "storefront.fill")
                    .font(.system(size: isSelected ? 18 : 13, weight: .medium))
                    .foregroundColor(isSelected ? .white : pinColor)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Category Chip

private struct MapCategoryChip: View {
    let category: DiscountCategory
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 5) {
                Image(systemName: category.icon)
                    .font(.system(size: 12, weight: .medium))
                Text(category.name)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
            }
            .foregroundColor(isSelected ? .white : .gray900)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(isSelected ? Color.colorPrimary : Color(.secondarySystemGroupedBackground))
            .clipShape(Capsule())
            .shadow(color: .black.opacity(isSelected ? 0 : 0.08), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

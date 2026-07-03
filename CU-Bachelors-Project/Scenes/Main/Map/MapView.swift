import SwiftUI
import MapKit

struct MapView: View {
    
    //MARK: - Properties
    
    @State private var viewModel: MapViewModel
    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.6941, longitude: 44.8337),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ))
    
    //MARK: - Init
    
    init(viewModel: MapViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    //MARK: - Body
    
    var body: some View {
        ZStack(alignment: .top) {
            ZStack(alignment: .bottom) {
                mapLayer
                if let discount = viewModel.selectedDiscount {
                    MapDiscountCard(
                        discount: discount,
                        onViewOffer: { viewModel.onViewOffer?(discount) },
                        onDismiss: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                viewModel.clearSelection()
                            }
                        }
                    )
                    .padding(.horizontal, 12)
                    .padding(.bottom, 8)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
                }
            }
            
            categoryChips
                .zIndex(2)
        }
        .navigationTitle("აღმოაჩინე რუკაზე")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
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
    
    //MARK: - Subviews
    
    private var mapLayer: some View {
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
    }
    
    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.categories) { category in
                    MapCategoryChip(
                        category: category,
                        isSelected: viewModel.selectedCategoryId == category.id,
                        onTap: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                viewModel.selectCategory(category.id)
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(.ultraThinMaterial)
    }
}

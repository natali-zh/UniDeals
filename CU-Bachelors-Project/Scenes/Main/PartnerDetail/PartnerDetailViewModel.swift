import CoreLocation
import Foundation

@MainActor
@Observable
final class PartnerDetailViewModel {

    // MARK: - Dependencies

    private let discountService: DiscountServiceProtocol

    // MARK: - State

    let partner: Partner
    var offers: [Discount] = []
    var isLoading = false

    // MARK: - Navigation callbacks

    var onBack: (() -> Void)?
    var onViewOnMap: ((Discount) -> Void)?
    var onOfferTapped: ((String) -> Void)?

    // MARK: - Init

    init(partner: Partner, discountService: DiscountServiceProtocol) {
        self.partner = partner
        self.discountService = discountService
    }

    convenience init(partner: Partner) {
        self.init(partner: partner, discountService: DiscountService.shared)
    }

    // MARK: - Computed

    func distanceText(for discount: Discount) -> String {
        if let userCoord = LocationManager.shared.userLocation {
            let userLoc = CLLocation(latitude: userCoord.latitude, longitude: userCoord.longitude)
            let discountLoc = CLLocation(latitude: discount.latitude, longitude: discount.longitude)
            let km = userLoc.distance(from: discountLoc) / 1000.0
            return DiscountFormatter.distanceText(km)
        }
        return DiscountFormatter.distanceText(discount.distanceKm)
    }

    // MARK: - Methods

    func loadOffers() async {
        isLoading = true
        let all = (try? await discountService.fetchAllDiscounts()) ?? []
        let pid = partner.id ?? ""
        let pname = partner.name.lowercased()
        offers = all.filter {
            $0.storeId == pid || $0.storeName.lowercased() == pname
        }
        isLoading = false
    }

}

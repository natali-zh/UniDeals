import CoreLocation
import Foundation
import Combine

@MainActor
final class DiscountDetailViewModel: ObservableObject {

    // MARK: - Dependencies

    private let partnerService: PartnerServiceProtocol

    // MARK: - Published

    let discount: Discount
    @Published var partner: Partner?
    @Published var isSaved: Bool

    // MARK: - Navigation callbacks

    var onBack: (() -> Void)?
    var onViewOnMap: ((Discount) -> Void)?
    var onPartnerTapped: ((String) -> Void)?

    // MARK: - Init

    init(
        discount: Discount,
        partnerService: PartnerServiceProtocol = PartnerService.shared
    ) {
        self.discount = discount
        self.isSaved = discount.isSaved
        self.partnerService = partnerService
    }

    // MARK: - Methods

    func loadPartner() async {
        async let partnerFetch = partnerService.fetchPartner(id: discount.storeId)
        let savedIds: [String]
        if let uid = SessionManager.shared.userId {
            savedIds = (try? await SavedDiscountsService.shared.fetchSavedIds(uid: uid)) ?? []
        } else {
            savedIds = []
        }
        partner = try? await partnerFetch
        if let id = discount.id {
            isSaved = savedIds.contains(id)
        }
    }

    func toggleSave() {
        guard let id = discount.id, let uid = SessionManager.shared.userId else { return }
        isSaved.toggle()
        Task {
            if isSaved {
                try? await SavedDiscountsService.shared.save(discountId: id, uid: uid)
            } else {
                try? await SavedDiscountsService.shared.unsave(discountId: id, uid: uid)
            }
        }
    }

    // MARK: - Computed display helpers

    var daysLeftText: String { DiscountFormatter.daysLeftText(for: discount.endDate) }
    var daysLeftIsUrgent: Bool { DiscountFormatter.isUrgent(endDate: discount.endDate) }
    var isExpired: Bool { DiscountFormatter.isExpired(endDate: discount.endDate) }
    var formattedEndDate: String { DiscountFormatter.formattedDate(discount.endDate) }
    var distanceText: String {
        if let userCoord = LocationManager.shared.userLocation {
            let userLoc = CLLocation(latitude: userCoord.latitude, longitude: userCoord.longitude)
            let discountLoc = CLLocation(latitude: discount.latitude, longitude: discount.longitude)
            let km = userLoc.distance(from: discountLoc) / 1000.0
            return DiscountFormatter.distanceText(km)
        }
        return DiscountFormatter.distanceText(discount.distanceKm)
    }
}

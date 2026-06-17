//
//  CardViewModel.swift
//  CU-Bachelors-Project
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

@MainActor
@Observable
final class CardViewModel {

    // MARK: - Published

    var user: User?
    var qrImage: Image?

    // MARK: - Dependencies

    private let userManager: UserManager
    private let sessionManager: SessionManager

    // MARK: - Init

    init(userManager: UserManager = .shared, sessionManager: SessionManager = .shared) {
        self.userManager = userManager
        self.sessionManager = sessionManager
    }

    // MARK: - Methods

    func load() async {
        if userManager.currentUser == nil {
            await userManager.fetchUser()
        }
        user = userManager.currentUser
        generateQR()
    }

    // MARK: - Computed display

    var validityText: String {
        let now = Date()
        let cal = Calendar.current
        let year = cal.component(.year, from: now)
        let month = cal.component(.month, from: now)
        let startYear = month >= 9 ? year : year - 1
        return "09/\(startYear) – 06/\(startYear + 1)"
    }

    // MARK: - Private

    private func generateQR() {
        guard let uid = sessionManager.userId else { return }
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(uid.utf8)
        filter.correctionLevel = "H"
        guard let outputImage = filter.outputImage else { return }
        let scaled = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return }
        qrImage = Image(uiImage: UIImage(cgImage: cgImage))
    }
}

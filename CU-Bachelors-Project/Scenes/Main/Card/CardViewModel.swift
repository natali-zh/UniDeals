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
        guard let semester = user?.semester else { return "–" }
        let (enrollmentYear, graduationYear) = academicYears(for: semester)
        return "09/\(enrollmentYear) – 06/\(graduationYear)"
    }

    var isExpired: Bool {
        guard let semester = user?.semester else { return false }
        let (_, graduationYear) = academicYears(for: semester)
        let now = Date()
        let year = Calendar.current.component(.year, from: now)
        let month = Calendar.current.component(.month, from: now)
        return year > graduationYear || (year == graduationYear && month > 6)
    }

    private func academicYears(for semester: Int) -> (enrollment: Int, graduation: Int) {
        let now = Date()
        let cal = Calendar.current
        let year = cal.component(.year, from: now)
        let month = cal.component(.month, from: now)
        let academicStart = month >= 9 ? year : year - 1
        let enrollmentYear = academicStart - (semester - 1) / 2
        return (enrollmentYear, enrollmentYear + 4)
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

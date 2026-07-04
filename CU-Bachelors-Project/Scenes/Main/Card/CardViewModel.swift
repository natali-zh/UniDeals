import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

@MainActor
@Observable
final class CardViewModel {

    // MARK: - Properties

    var user: User?
    var qrImage: Image?

    // MARK: - Dependencies

    private let userManager: UserManager
    private let sessionManager: SessionManager

    // MARK: - Computed properties

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

    // MARK: - Init

    init(userManager: UserManager, sessionManager: SessionManager) {
        self.userManager = userManager
        self.sessionManager = sessionManager
    }

    convenience init() {
        self.init(userManager: .shared, sessionManager: .shared)
    }

    // MARK: - Methods

    func load() async {
        if userManager.currentUser == nil {
            await userManager.fetchUser()
        }
        user = userManager.currentUser
        await generateQR()
    }

    // MARK: - Private

    private func academicYears(for semester: Int) -> (enrollment: Int, graduation: Int) {
        let now = Date()
        let cal = Calendar.current
        let year = cal.component(.year, from: now)
        let month = cal.component(.month, from: now)
        let academicStart = month >= 9 ? year : year - 1
        let enrollmentYear = academicStart - (semester - 1) / 2
        return (enrollmentYear, enrollmentYear + 4)
    }

    private func generateQR() async {
        guard let uid = sessionManager.userId else { return }
        let rendered = await Task.detached(priority: .userInitiated) {
            let context = CIContext()
            let filter = CIFilter.qrCodeGenerator()
            filter.message = Data(uid.utf8)
            filter.correctionLevel = "H"
            guard let outputImage = filter.outputImage else { return nil as UIImage? }
            let scaled = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
            guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return nil as UIImage? }
            return UIImage(cgImage: cgImage)
        }.value
        if let rendered {
            qrImage = Image(uiImage: rendered)
        }
    }
}

//
//  ProfileViewModel.swift
//  CU-Bachelors-Project
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore

@MainActor
@Observable
final class ProfileViewModel {

    var user: User?
    var isUploadingPhoto = false
    var uploadError: String? = nil
    var isUpdatingName = false

    var onLogOut: (() -> Void)?
    var onEditUniversity: (() -> Void)?
    var onEditSemester: (() -> Void)?
    var onSavedDiscounts: (() -> Void)?

    var universityDisplay: String { user?.university ?? "—" }

    var semesterDisplay: String {
        guard let s = user?.semester else { return "—" }
        return "\(s) სემესტრი"
    }

    var validityDisplay: String {
        guard let semester = user?.semester else { return "" }
        let (enrollment, graduation) = academicYears(for: semester)
        return "09/\(enrollment) – 06/\(graduation)"
    }

    var isExpired: Bool {
        guard let semester = user?.semester else { return false }
        let (_, graduation) = academicYears(for: semester)
        let now = Date()
        let year = Calendar.current.component(.year, from: now)
        let month = Calendar.current.component(.month, from: now)
        return year > graduation || (year == graduation && month > 6)
    }

    var appVersion: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "ვერსია \(v) (\(b))"
    }

    var savedCount: Int = 0

    func load() async {
        if UserManager.shared.currentUser == nil {
            await UserManager.shared.fetchUser()
        }
        user = UserManager.shared.currentUser
        if let uid = SessionManager.shared.userId {
            savedCount = (try? await SavedDiscountsService.shared.fetchSavedIds(uid: uid))?.count ?? 0
        }
    }

    func updateName(_ newName: String) async {
        let trimmed = newName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, let uid = SessionManager.shared.userId else { return }
        isUpdatingName = true
        do {
            try await Firestore.firestore()
                .collection(FirestorePaths.users)
                .document(uid)
                .updateData(["fullname": trimmed])
            UserManager.shared.currentUser?.fullname = trimmed
            user?.fullname = trimmed
        } catch {
            uploadError = error.localizedDescription
        }
        isUpdatingName = false
    }

    func uploadPhoto(_ image: UIImage) async {
        guard let uid = SessionManager.shared.userId,
              let data = image.jpegData(compressionQuality: 0.75) else { return }

        isUploadingPhoto = true
        uploadError = nil

        do {
            let ref = Storage.storage().reference().child("profile_images/\(uid).jpg")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            _ = try await ref.putDataAsync(data, metadata: metadata)
            let url = try await ref.downloadURL()
            let urlString = url.absoluteString

            try await Firestore.firestore()
                .collection(FirestorePaths.users)
                .document(uid)
                .updateData(["imageUrl": urlString])

            UserManager.shared.currentUser?.imageUrl = urlString
            user?.imageUrl = urlString
        } catch {
            uploadError = error.localizedDescription
            print("Storage upload error: \(error)")
        }

        isUploadingPhoto = false
    }

    func logOut() {
        SessionManager.shared.logout()
        onLogOut?()
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
}

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

    var universityDisplay: String { user?.university ?? "—" }

    var semesterDisplay: String {
        guard let s = user?.semester else { return "—" }
        return "\(s) სემესტრი"
    }

    var appVersion: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "ვერსია \(v) (\(b))"
    }

    func load() async {
        if UserManager.shared.currentUser == nil {
            await UserManager.shared.fetchUser()
        }
        user = UserManager.shared.currentUser
    }

    func updateName(_ newName: String) async {
        let trimmed = newName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, let uid = SessionManager.shared.userId else { return }
        isUpdatingName = true
        do {
            try await Firestore.firestore()
                .collection(FirestoreCollections.users)
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
                .collection(FirestoreCollections.users)
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


}

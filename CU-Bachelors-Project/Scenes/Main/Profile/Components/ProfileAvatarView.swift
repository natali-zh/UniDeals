import SwiftUI
import PhotosUI

struct ProfileAvatarView: View {

    let imageUrl: String?
    let isUploading: Bool
    let onImageSelected: (UIImage) -> Void

    @State private var showPhotoSource = false
    @State private var showPhotoPicker = false
    @State private var showCamera = false
    @State private var photoPickerItem: PhotosPickerItem? = nil

    private var cameraAvailable: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            avatarImage
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)

            if isUploading {
                Circle()
                    .fill(Color.black.opacity(0.4))
                    .frame(width: 100, height: 100)
                    .overlay(ProgressView().tint(.white))
            } else {
                cameraButton
            }
        }
        .confirmationDialog("პროფილის ფოტო", isPresented: $showPhotoSource, titleVisibility: .visible) {
            Button("ფოტოთა ბიბლიოთეკა") { showPhotoPicker = true }
            if cameraAvailable {
                Button("კამერა") { showCamera = true }
            }
            Button("გაუქმება", role: .cancel) {}
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $photoPickerItem, matching: .images)
        .sheet(isPresented: $showCamera) {
            CameraView(onImage: onImageSelected)
        }
        .onChange(of: photoPickerItem) { _, item in
            guard let item, !isUploading else { return }
            let captured = item
            photoPickerItem = nil
            Task {
                if let data = try? await captured.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    onImageSelected(image)
                }
            }
        }
    }

    @ViewBuilder
    private var avatarImage: some View {
        if let urlStr = imageUrl, let url = URL(string: urlStr) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                default:
                    placeholderAvatar
                }
            }
        } else {
            placeholderAvatar
        }
    }

    private var placeholderAvatar: some View {
        Circle()
            .fill(Color.gray100)
            .overlay(
                Image(systemName: "person.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.gray300)
            )
    }

    private var cameraButton: some View {
        Button { showPhotoSource = true } label: {
            ZStack {
                Circle()
                    .fill(Color.colorPrimary)
                    .frame(width: 26, height: 26)
                Image(systemName: "camera.fill")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .offset(x: 2, y: 2)
    }
}

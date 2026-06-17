//
//  ProfileHeaderView.swift
//  CU-Bachelors-Project
//

import SwiftUI

struct ProfileHeaderView: View {

    let user: User?
    let isUploading: Bool
    let onImageSelected: (UIImage) -> Void
    let onNameTap: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            ProfileAvatarView(
                imageUrl: user?.imageUrl,
                isUploading: isUploading,
                onImageSelected: onImageSelected
            )

            VStack(spacing: 4) {
                Button(action: onNameTap) {
                    HStack(spacing: 6) {
                        Text(user?.fullname ?? "—")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.gray900)
                        Image(systemName: "pencil")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.gray300)
                    }
                }
                .buttonStyle(.plain)

                Text(user?.email ?? "")
                    .font(.system(size: 14))
                    .foregroundColor(.gray500)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

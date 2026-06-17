//
//  ProfileHeaderView.swift
//  CU-Bachelors-Project
//

import SwiftUI

struct ProfileHeaderView: View {

    let user: User?
    let isUploading: Bool
    let onImageSelected: (UIImage) -> Void

    var body: some View {
        VStack(spacing: 12) {
            ProfileAvatarView(
                imageUrl: user?.imageUrl,
                isUploading: isUploading,
                onImageSelected: onImageSelected
            )

            VStack(spacing: 4) {
                Text(user?.fullname ?? "—")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.gray900)

                Text(user?.email ?? "")
                    .font(.system(size: 14))
                    .foregroundColor(.gray500)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

//
//  ProfileView.swift
//  CU-Bachelors-Project
//

import SwiftUI

struct ProfileView: View {

    @State private var viewModel: ProfileViewModel
    @State private var showLogOutAlert = false

    init(viewModel: ProfileViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ProfileHeaderView(
                    user: viewModel.user,
                    isUploading: viewModel.isUploadingPhoto,
                    onImageSelected: { image in Task { await viewModel.uploadPhoto(image) } }
                )
                .padding(.bottom, 32)

                VStack(spacing: 0) {
                    SettingsRow(icon: "bookmark.fill", iconColor: .gray500, title: "შენახული შეთავაზებები") {
                        viewModel.onSavedDiscounts?()
                    }
                }
                .settingsCard()
                .padding(.bottom, 12)

                VStack(spacing: 0) {
                    SettingsRow(icon: "building.columns.fill", iconColor: .gray500, title: "უნივერსიტეტი", value: viewModel.universityDisplay) {
                        viewModel.onEditUniversity?()
                    }
                    Divider().padding(.leading, 20)
                    SettingsRow(icon: "graduationcap.fill", iconColor: .gray500, title: "სემესტრი", value: viewModel.semesterDisplay) {
                        viewModel.onEditSemester?()
                    }
                }
                .settingsCard()
                .padding(.bottom, 12)

                VStack(spacing: 0) {
                    SettingsRow(icon: "rectangle.portrait.and.arrow.right", iconColor: .red, title: "გასვლა", titleColor: .red, showChevron: false) {
                        showLogOutAlert = true
                    }
                }
                .settingsCard()

                Spacer(minLength: 40)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
        }
        .background(Color(red: 0.97, green: 0.97, blue: 0.98).ignoresSafeArea())
        .navigationTitle("პროფილი")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
        .alert("გასვლა", isPresented: $showLogOutAlert) {
            Button("გაუქმება", role: .cancel) {}
            Button("გასვლა", role: .destructive) { viewModel.logOut() }
        } message: {
            Text("დარწმუნებული ხარ, რომ გსურს გასვლა?")
        }
        .alert("შეცდომა", isPresented: Binding(
            get: { viewModel.uploadError != nil },
            set: { if !$0 { viewModel.uploadError = nil } }
        )) {
            Button("კარგი", role: .cancel) {}
        } message: {
            Text(viewModel.uploadError ?? "")
        }
    }
}

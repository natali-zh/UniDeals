import SwiftUI

struct ProfileView: View {

    @State private var viewModel: ProfileViewModel
    @State private var showLogOutAlert = false
    @State private var showEditNameAlert = false
    @State private var editNameText = ""
    @AppStorage("appColorScheme") private var colorSchemeRaw: String = "system"

    private var currentThemeLabel: String {
        switch colorSchemeRaw {
        case "dark": return "მუქი"
        case "light": return "ნათელი"
        default: return "სისტემა"
        }
    }

    private func applyColorScheme(_ value: String) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return }
        switch value {
        case "dark":  window.overrideUserInterfaceStyle = .dark
        case "light": window.overrideUserInterfaceStyle = .light
        default:      window.overrideUserInterfaceStyle = .unspecified
        }
    }

    init(viewModel: ProfileViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ProfileHeaderView(
                    user: viewModel.user,
                    isUploading: viewModel.isUploadingPhoto,
                    onImageSelected: { image in Task { await viewModel.uploadPhoto(image) } },
                    onNameTap: {
                        editNameText = viewModel.user?.fullname ?? ""
                        showEditNameAlert = true
                    }
                )
                .padding(.bottom, 32)

                // University & semester
                VStack(alignment: .leading, spacing: 0) {
                    SettingsRow(
                        icon: "building.columns.fill",
                        iconColor: .gray500,
                        title: "უნივერსიტეტი",
                        value: viewModel.universityDisplay
                    ) {
                        viewModel.onEditUniversity?()
                    }
                    Divider().padding(.leading, 20)
                    SettingsRow(
                        icon: "graduationcap.fill",
                        iconColor: .gray500,
                        title: "სემესტრი",
                        value: viewModel.semesterDisplay
                    ) {
                        viewModel.onEditSemester?()
                    }
                }
                .settingsCard()
                .padding(.bottom, 12)

                // Appearance
                VStack(spacing: 0) {
                    Menu {
                        ForEach([("system", "სისტემის რეჟიმი"), ("light", "ნათელი რეჟიმი"), ("dark", "მუქი რეჟიმი")], id: \.0) { value, label in
                            Button {
                                colorSchemeRaw = value
                                applyColorScheme(value)
                            } label: {
                                if colorSchemeRaw == value {
                                    Label(label, systemImage: "checkmark")
                                } else {
                                    Text(label)
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: "moon.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray500)
                                .frame(width: 22)
                            Text("ვიზუალი")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.gray900)
                            Spacer()
                            Text(currentThemeLabel)
                                .font(.system(size: 14))
                                .foregroundColor(.gray500)
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray300)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                .settingsCard()
                .padding(.bottom, 12)

                // Log out
                VStack(spacing: 0) {
                    SettingsRow(
                        icon: "rectangle.portrait.and.arrow.right",
                        iconColor: .red,
                        title: "გასვლა",
                        titleColor: .red,
                        showChevron: false
                    ) {
                        showLogOutAlert = true
                    }
                }
                .settingsCard()

                // App version
                Text(viewModel.appVersion)
                    .font(.system(size: 12))
                    .foregroundColor(.gray300)
                    .padding(.top, 32)
                    .padding(.bottom, 16)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(false)
        .navigationTitle("პარამეტრები")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
        .alert("სახელის შეცვლა", isPresented: $showEditNameAlert) {
            TextField("სახელი და გვარი", text: $editNameText)
            Button("გაუქმება", role: .cancel) {}
            Button("შენახვა") {
                Task { await viewModel.updateName(editNameText) }
            }
        } message: {
            Text("შეიყვანე შენი სახელი და გვარი")
        }
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

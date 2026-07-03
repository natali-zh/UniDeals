import SwiftUI

struct AppearancePicker: View {

    @AppStorage("appColorScheme") private var colorSchemeRaw: String = "system"

    private var currentLabel: String {
        switch colorSchemeRaw {
        case "dark":  return "მუქი"
        case "light": return "ნათელი"
        default:      return "სისტემა"
        }
    }

    var body: some View {
        Menu {
            ForEach([("system", "სისტემის რეჟიმი"), ("light", "ნათელი რეჟიმი"), ("dark", "მუქი რეჟიმი")], id: \.0) { value, label in
                Button(action: {
                    colorSchemeRaw = value
                    applyColorScheme(value)
                }) {
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
                Text(currentLabel)
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

    private func applyColorScheme(_ value: String) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return }
        switch value {
        case "dark":  window.overrideUserInterfaceStyle = .dark
        case "light": window.overrideUserInterfaceStyle = .light
        default:      window.overrideUserInterfaceStyle = .unspecified
        }
    }
}

import SwiftUI

struct PartnerContactButtons: View {

    let phone: String?
    let website: String?

    var body: some View {
        if phone != nil || website != nil {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 12) {
                    if let phone {
                        contactButton(icon: "phone.fill", title: "დარეკვა") {
                            if let url = URL(string: "tel://\(phone.replacingOccurrences(of: " ", with: ""))") {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                    if let website {
                        contactButton(icon: "globe", title: "ვებსაიტი") {
                            if let url = URL(string: website) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)

                Divider().padding(.horizontal, 20)
            }
            .padding(.top, 16)
        }
    }

    private func contactButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.colorPrimary)
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.colorPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.colorPrimary.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

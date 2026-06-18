//
//  ExpiringSoonSection.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 17.06.26.
//

import SwiftUI

struct ExpiringSoonSection: View {
    let discounts: [Discount]
    let onSeeAll: () -> Void
    let onTap: (String) -> Void
    var onSave: ((String) -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("მალე იწურება")
                    .sectionTitleStyle()
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
                Spacer()
                Button("ყველას ნახვა") { onSeeAll() }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.colorPrimary)
            }
            .padding(.horizontal, 20)

            VStack(spacing: 12) {
                ForEach(discounts) { discount in
                    ExpiringCard(discount: discount, onSave: onSave.map { cb in { cb(discount.id ?? "") } })
                        .onTapGesture { onTap(discount.id ?? "") }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

private struct ExpiringCard: View {
    let discount: Discount
    var onSave: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 0) {
            ExpiringCardImage(imageUrl: discount.imageUrl)
                .frame(width: 110, height: 110)

            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top, spacing: 8) {
                    Text(discount.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.gray900)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if let onSave {
                        Button(action: onSave) {
                            Image(systemName: discount.isSaved ? "heart.fill" : "heart")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(discount.isSaved ? .red : .white)
                                .padding(7)
                                .background(Circle().fill(Color.black.opacity(0.18)))
                        }
                        .buttonStyle(.plain)
                    }
                }

                Text(discount.storeName)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.gray500)

                Spacer(minLength: 8)

                HStack(spacing: 4) {
                    Image(systemName: "location")
                        .font(.system(size: 11))
                        .foregroundColor(.gray500)
                    Text(String(format: "%.1f km", discount.distanceKm))
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray500)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 110)
        .cardStyle(cornerRadius: 16)
    }
}

private struct ExpiringCardImage: View {
    let imageUrl: String?

    var body: some View {
        Color.gray100
            .overlay(content)
            .clipShape(
                .rect(
                    topLeadingRadius: 16,
                    bottomLeadingRadius: 16,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 0
                )
            )
    }

    @ViewBuilder
    private var content: some View {
        if let imageUrl, let url = URL(string: imageUrl), !imageUrl.isEmpty {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill).clipped()
                default:
                    placeholderIcon
                }
            }
        } else {
            placeholderIcon
        }
    }

    private var placeholderIcon: some View {
        Image(systemName: "photo")
            .font(.system(size: 28))
            .foregroundColor(Color.gray500.opacity(0.3))
    }
}

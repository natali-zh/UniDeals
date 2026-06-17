//
//  DiscountsGridView.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 17.06.26.
//

import SwiftUI

struct DiscountsGridView: View {
    let discounts: [Discount]
    let onTap: (String) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ნაპოვნია \(discounts.count) შეთავაზება")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray500)
                .padding(.horizontal, 20)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(discounts) { discount in
                    DiscountGridCard(discount: discount)
                        .onTapGesture { onTap(discount.id ?? "") }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct DiscountGridCard: View {
    let discount: Discount

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                DiscountGridCardImage(imageUrl: discount.imageUrl)

                Text(discount.label)
                    .badgeStyle(fontSize: 11, horizontalPadding: 8, verticalPadding: 5)
                    .padding(8)
            }
            .frame(height: 120)

            VStack(alignment: .leading, spacing: 3) {
                Text(discount.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.gray900)
                    .lineLimit(2)

                Text(discount.storeName)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.gray500)
                    .lineLimit(1)

                Spacer()

                HStack(spacing: 3) {
                    Image(systemName: "location")
                        .font(.system(size: 10))
                        .foregroundColor(.gray500)
                    Text(String(format: "%.1f km", discount.distanceKm))
                        .font(.system(size: 11))
                        .foregroundColor(.gray500)
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .frame(height: 220)
        .cardStyle(cornerRadius: 14)
    }
}

private struct DiscountGridCardImage: View {
    let imageUrl: String?

    var body: some View {
        Color.gray100
            .overlay(content)
            .clipShape(.rect(topLeadingRadius: 14, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 14))
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

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
    var onSave: ((String) -> Void)? = nil

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
                    DiscountGridCard(discount: discount, onSave: onSave.map { cb in { cb(discount.id ?? "") } })
                        .onTapGesture { onTap(discount.id ?? "") }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct DiscountGridCard: View {
    let discount: Discount
    var onSave: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                DiscountGridCardImage(imageUrl: discount.imageUrl)

                Text(discount.label)
                    .badgeStyle(fontSize: 11, horizontalPadding: 8, verticalPadding: 5)
                    .padding(8)

                if let onSave {
                    SaveButton(isSaved: discount.isSaved, action: onSave)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding(8)
                }
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

    private var content: some View {
        RemoteImage(url: imageUrl, placeholder: Image(systemName: "photo"))
    }
}

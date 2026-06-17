//
//  FilterSheet.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 17.06.26.
//

import SwiftUI

struct FilterSheet: View {
    @Binding var filter: DiscountFilter
    let onApply: () -> Void
    let onReset: () -> Void

    @Environment(\.dismiss) private var dismiss

    private let distanceOptions: [(label: String, value: Double?)] = [
        ("ნებისმიერი", nil),
        ("1 კმ-მდე", 1),
        ("5 კმ-მდე", 5),
        ("10 კმ-მდე", 10)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            handle
            header

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    sortSection
                    distanceSection
                    discountTypeSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }

            actionButtons
        }
        .background(Color.white)
    }

    // MARK: - Subviews

    private var handle: some View {
        Capsule()
            .fill(Color.gray300)
            .frame(width: 40, height: 4)
            .frame(maxWidth: .infinity)
            .padding(.top, 12)
    }

    private var header: some View {
        Text("ფილტრი")
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.gray900)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 12)
    }

    private var sortSection: some View {
        FilterSectionContainer(
            title: "დალაგება",
            items: DiscountFilter.SortOption.allCases,
            label: { $0.rawValue },
            isSelected: { filter.sortBy == $0 },
            onSelect: { filter.sortBy = $0 }
        )
    }

    private var distanceSection: some View {
        FilterSectionContainer(
            title: "მანძილი",
            items: distanceOptions.map { $0.label },
            label: { $0 },
            isSelected: { label in
                filter.maxDistanceKm == distanceOptions.first(where: { $0.label == label })?.value
            },
            onSelect: { label in
                filter.maxDistanceKm = distanceOptions.first(where: { $0.label == label })?.value
            }
        )
    }

    private var discountTypeSection: some View {
        FilterSectionContainer(
            title: "ფასდაკლების ტიპი",
            items: DiscountFilter.DiscountTypeFilter.allCases,
            label: { $0.rawValue },
            isSelected: { filter.discountType == $0 },
            onSelect: { filter.discountType = $0 }
        )
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button {
                onReset()
                dismiss()
            } label: {
                Text("გასუფთავება")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.gray700)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.gray100)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            Button {
                onApply()
                dismiss()
            } label: {
                Text("გამოყენება")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.colorPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white.shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: -2))
    }
}

// MARK: - Reusable subcomponents

private struct FilterSectionContainer<Item: Hashable>: View {
    let title: String
    let items: [Item]
    let label: (Item) -> String
    let isSelected: (Item) -> Bool
    let onSelect: (Item) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.gray900)

            HStack(spacing: 8) {
                ForEach(items, id: \.self) { item in
                    FilterChip(
                        label: label(item),
                        isSelected: isSelected(item),
                        onTap: { onSelect(item) }
                    )
                }
                Spacer()
            }
        }
    }
}

private struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .gray700)
                .padding(.horizontal, 16)
                .padding(.vertical, 9)
                .background(isSelected ? Color.colorPrimary : Color.gray100)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

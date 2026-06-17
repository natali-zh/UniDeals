//
//  FilterSheet.swift
//  CU-Bachelors-Project
//

import SwiftUI

struct FilterSheet: View {
    @Binding var filter: DiscountFilter
    @Binding var selectedCategories: Set<String>
    let categories: [DiscountCategory]
    let onApply: () -> Void
    let onReset: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                header

                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        sortSection
                        discountTypeSection
                        categorySection
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                }
            }
            .padding(.horizontal, 20)

            actionButtons
        }
        .background(Color.white)
    }

    // MARK: - Subviews

    private var header: some View {
        Text("ფილტრი")
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.gray900)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 12)
            .padding(.bottom, 12)
    }

    private var sortSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("დალაგება")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.gray900)

            VStack(spacing: 0) {
                ForEach(DiscountFilter.SortOption.allCases, id: \.self) { option in
                    Button {
                        filter.sortBy = (filter.sortBy == option) ? nil : option
                    } label: {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .stroke(filter.sortBy == option ? Color.colorPrimary : Color.gray300, lineWidth: 2)
                                    .frame(width: 20, height: 20)
                                if filter.sortBy == option {
                                    Circle()
                                        .fill(Color.colorPrimary)
                                        .frame(width: 10, height: 10)
                                }
                            }
                            Text(option.label)
                                .font(.system(size: 15, weight: filter.sortBy == option ? .semibold : .regular))
                                .foregroundColor(filter.sortBy == option ? .gray900 : .gray700)
                            Spacer()
                            Text(option.arrow)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(filter.sortBy == option ? .colorPrimary : .gray300)
                        }
                        .padding(.vertical, 13)
                    }
                    .buttonStyle(.plain)

                    if option != DiscountFilter.SortOption.allCases.last {
                        Divider()
                    }
                }
            }
            .padding(.horizontal, 4)
        }
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

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("კატეგორია")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.gray900)

            FlowLayout(spacing: 8) {
                FilterChip(label: "ყველა", isSelected: selectedCategories.isEmpty) {
                    selectedCategories = []
                }
                ForEach(categories) { cat in
                    FilterChip(
                        label: cat.name,
                        isSelected: selectedCategories.contains(cat.id)
                    ) {
                        if selectedCategories.contains(cat.id) {
                            selectedCategories.remove(cat.id)
                        } else {
                            selectedCategories.insert(cat.id)
                        }
                    }
                }
            }
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button {
                onReset()
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

// MARK: - Flow layout for wrapping chips

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var height: CGFloat = 0
        var x: CGFloat = 0
        var rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > width, x > 0 {
                height += rowHeight + spacing
                x = 0
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        height += rowHeight
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                y += rowHeight + spacing
                x = bounds.minX
                rowHeight = 0
            }
            view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

// MARK: - Reusable chip

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

            FlowLayout(spacing: 8) {
                ForEach(items, id: \.self) { item in
                    FilterChip(
                        label: label(item),
                        isSelected: isSelected(item),
                        onTap: { onSelect(item) }
                    )
                }
            }
        }
    }
}

struct FilterChip: View {
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

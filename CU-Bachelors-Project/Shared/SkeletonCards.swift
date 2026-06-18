import SwiftUI

// MARK: - Base

private struct SkeletonBlock: View {
    var cornerRadius: CGFloat = 8
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.gray.opacity(0.15))
    }
}

// MARK: - Featured skeleton

struct FeaturedCardSkeleton: View {
    var body: some View {
        SkeletonBlock(cornerRadius: 20)
            .frame(height: 210)
            .shimmer()
            .padding(.horizontal, 20)
    }
}

// MARK: - Nearby skeleton

struct NearbySectionSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SkeletonBlock(cornerRadius: 6)
                .frame(width: 120, height: 18)
                .padding(.horizontal, 20)
                .shimmer()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(0..<4, id: \.self) { _ in
                        NearbyCardSkeleton()
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

private struct NearbyCardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SkeletonBlock(cornerRadius: 0)
                .frame(width: 170, height: 130)
                .clipShape(.rect(topLeadingRadius: 16, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 16))

            VStack(alignment: .leading, spacing: 8) {
                SkeletonBlock(cornerRadius: 4).frame(height: 14)
                SkeletonBlock(cornerRadius: 4).frame(width: 90, height: 11)
                SkeletonBlock(cornerRadius: 4).frame(width: 60, height: 11)
                    .padding(.top, 2)
            }
            .padding(12)
        }
        .frame(width: 170)
        .cardStyle()
        .shimmer()
    }
}

// MARK: - Expiring skeleton

struct ExpiringSectionSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SkeletonBlock(cornerRadius: 6)
                .frame(width: 110, height: 18)
                .padding(.horizontal, 20)
                .shimmer()

            VStack(spacing: 12) {
                ForEach(0..<3, id: \.self) { _ in
                    ExpiringCardSkeleton()
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

private struct ExpiringCardSkeleton: View {
    var body: some View {
        HStack(spacing: 0) {
            SkeletonBlock(cornerRadius: 0)
                .frame(width: 110, height: 110)
                .clipShape(.rect(topLeadingRadius: 16, bottomLeadingRadius: 16, bottomTrailingRadius: 0, topTrailingRadius: 0))

            VStack(alignment: .leading, spacing: 8) {
                SkeletonBlock(cornerRadius: 4).frame(height: 15)
                SkeletonBlock(cornerRadius: 4).frame(width: 100, height: 13)
                Spacer()
                SkeletonBlock(cornerRadius: 4).frame(width: 60, height: 11)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 110)
        .cardStyle(cornerRadius: 16)
        .shimmer()
    }
}

// MARK: - Grid skeleton

struct DiscountsGridSkeleton: View {
    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(0..<6, id: \.self) { _ in
                GridCardSkeleton()
            }
        }
        .padding(.horizontal, 16)
    }
}

private struct GridCardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SkeletonBlock(cornerRadius: 0)
                .frame(height: 120)
                .clipShape(.rect(topLeadingRadius: 14, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 14))

            VStack(alignment: .leading, spacing: 6) {
                SkeletonBlock(cornerRadius: 4).frame(height: 13)
                SkeletonBlock(cornerRadius: 4).frame(width: 70, height: 11)
                Spacer()
                SkeletonBlock(cornerRadius: 4).frame(width: 50, height: 11)
            }
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .frame(height: 220)
        .cardStyle(cornerRadius: 14)
        .shimmer()
    }
}

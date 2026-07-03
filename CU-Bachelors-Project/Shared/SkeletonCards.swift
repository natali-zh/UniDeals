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

// MARK: - Student card skeleton

struct CardSkeleton: View {
    var body: some View {
        VStack(spacing: 0) {
            headerBand
            cardBody
        }
        .background(
            LinearGradient(
                colors: [Color.colorPrimary, Color(red: 0.28, green: 0.18, blue: 0.72)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.colorPrimary.opacity(0.35), radius: 24, x: 0, y: 12)
        .padding(.horizontal, 24)
        .shimmer()
    }

    private var headerBand: some View {
        HStack {
            HStack(spacing: 8) {
                SkeletonBlock(cornerRadius: 8).frame(width: 34, height: 34)
                VStack(alignment: .leading, spacing: 4) {
                    SkeletonBlock(cornerRadius: 3).frame(width: 50, height: 8)
                    SkeletonBlock(cornerRadius: 3).frame(width: 36, height: 8)
                }
            }
            Spacer()
            SkeletonBlock(cornerRadius: 4).frame(width: 22, height: 22)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.12))
    }

    private var cardBody: some View {
        VStack(spacing: 20) {
            avatar
            nameAndUniversity
            Divider().background(Color.white.opacity(0.25)).padding(.horizontal, 24)
            validity
            qrPlaceholder
        }
    }

    private var avatar: some View {
        Circle()
            .fill(Color.white.opacity(0.2))
            .frame(width: 88, height: 88)
            .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 3))
            .padding(.top, 24)
    }

    private var nameAndUniversity: some View {
        VStack(spacing: 8) {
            SkeletonBlock(cornerRadius: 6).frame(width: 140, height: 20).opacity(0.35)
            SkeletonBlock(cornerRadius: 5).frame(width: 100, height: 14).opacity(0.25)
        }
    }

    private var validity: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                SkeletonBlock(cornerRadius: 3).frame(width: 50, height: 11).opacity(0.25)
                SkeletonBlock(cornerRadius: 3).frame(width: 80, height: 13).opacity(0.35)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 6) {
                SkeletonBlock(cornerRadius: 3).frame(width: 44, height: 11).opacity(0.25)
                SkeletonBlock(cornerRadius: 3).frame(width: 56, height: 13).opacity(0.35)
            }
        }
        .padding(.horizontal, 28)
    }

    private var qrPlaceholder: some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(Color.white.opacity(0.15))
            .frame(width: 134, height: 134)
            .padding(.bottom, 28)
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

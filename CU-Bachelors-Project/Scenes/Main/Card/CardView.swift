import SwiftUI

struct CardView: View {

    @State private var viewModel = CardViewModel()

    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.97, blue: 0.98).ignoresSafeArea()

            VStack(spacing: 24) {
                // Title
                Text("სტუდენტის ბარათი")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.gray900)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                if viewModel.user == nil {
                    CardSkeleton()
                } else {
                    studentCard
                }

                // Hint
                Text("შეთავაზების გამოსაყენებლად აჩვენეთ ბარათი პარტნიორ ობიექტში")
                    .font(.system(size: 13))
                    .foregroundColor(.gray500)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer()
            }
        }
        .navigationBarHidden(true)
        .task { await viewModel.load() }
    }

    // MARK: - Student card

    private var studentCard: some View {
        VStack(spacing: 0) {
            // Header band
            cardHeader

            // Body
            VStack(spacing: 20) {
                // Photo
                profilePhoto
                    .padding(.top, 24)

                // Name + university
                VStack(spacing: 6) {
                    Text(viewModel.user?.fullname ?? "სტუდენტი")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)

                    Text(viewModel.user?.university ?? "უნივერსიტეტი")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                }

                Divider()
                    .background(Color.white.opacity(0.25))
                    .padding(.horizontal, 24)

                // Validity
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("მოქმედია")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.65))
                        Text(viewModel.validityText)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("სტატუსი")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.65))
                        Text(viewModel.isExpired ? "ვადაგასული" : "აქტიური")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(viewModel.isExpired ? .red : .green)
                    }
                }
                .padding(.horizontal, 28)

                // QR code on white tile
                qrSection
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 28)
            }
        }
        .background(cardGradient)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.colorPrimary.opacity(0.35), radius: 24, x: 0, y: 12)
        .padding(.horizontal, 24)
    }

    // MARK: - Card header

    private var cardHeader: some View {
        HStack {
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 34, height: 34)
                    .overlay(
                        Text("U")
                            .font(.system(size: 17, weight: .black, design: .rounded))
                            .italic()
                            .foregroundColor(.colorPrimary)
                    )
                VStack(alignment: .leading, spacing: 0) {
                    Text("STUDENT")
                        .font(.system(size: 8, weight: .black))
                        .foregroundColor(.white)
                    Text("CARD")
                        .font(.system(size: 8, weight: .black))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            Spacer()
            Image(systemName: "building.columns")
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.12))
    }

    // MARK: - Profile photo

    @ViewBuilder
    private var profilePhoto: some View {
        if let urlStr = viewModel.user?.imageUrl, let url = URL(string: urlStr) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                        .frame(width: 88, height: 88)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                default:
                    placeholderAvatar
                }
            }
        } else {
            placeholderAvatar
        }
    }

    private var placeholderAvatar: some View {
        Circle()
            .fill(Color.white.opacity(0.2))
            .frame(width: 88, height: 88)
            .overlay(
                Image(systemName: "person.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.white.opacity(0.6))
            )
            .overlay(Circle().stroke(Color.white, lineWidth: 3))
    }

    // MARK: - QR section

    private var qrSection: some View {
        VStack(spacing: 12) {
            if let qr = viewModel.qrImage {
                qr
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 110)
                    .padding(12)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            } else {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .frame(width: 134, height: 134)
                    .overlay(ProgressView().tint(.gray500))
            }
            Text("დაასკანერეთ ბარათის გამოსაყენებლად")
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.55))
        }
    }

    // MARK: - Gradient

    private var cardGradient: some ShapeStyle {
        LinearGradient(
            colors: [
                Color.colorPrimary,
                Color(red: 0.28, green: 0.18, blue: 0.72)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    CardView()
}

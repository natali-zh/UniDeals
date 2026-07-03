import SwiftUI

struct CardView: View {
    
    //MARK: - Properties
    
    @State private var viewModel = CardViewModel()
    @State private var cardVisible = false
    
    //MARK: - Body
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            
            VStack(spacing: 24) {
                screenTitle
                cardContent
                hint
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .task { await viewModel.load() }
    }
    
    //MARK: - subviews
    
    private var screenTitle: some View {
        Text("სტუდენტის ბარათი")
            .font(.system(size: 22, weight: .bold))
            .foregroundColor(.gray900)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 16)
    }
    
    @ViewBuilder
    private var cardContent: some View {
        if let user = viewModel.user {
            StudentCardView(
                user: user,
                validityText: viewModel.validityText,
                isExpired: viewModel.isExpired,
                qrImage: viewModel.qrImage
            )
            .offset(y: cardVisible ? 0 : 40)
            .opacity(cardVisible ? 1 : 0)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                    cardVisible = true
                }
            }
        } else {
            CardSkeleton()
        }
    }
    
    private var hint: some View {
        Text("შეთავაზების გამოსაყენებლად აჩვენეთ ბარათი პარტნიორ ობიექტში")
            .font(.system(size: 13))
            .foregroundColor(.gray500)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
    }
}

#Preview {
    CardView()
}

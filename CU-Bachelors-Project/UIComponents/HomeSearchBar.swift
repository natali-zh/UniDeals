import SwiftUI

struct HomeSearchBar: View {

    //MARK: - Properties

    @Binding var query: String
    var isFilterActive: Bool = false
    var onFilterTap: (() -> Void)? = nil

    //MARK: - Body

    var body: some View {
        HStack(spacing: 12) {
            searchTextField
            filterButton
        }
        .padding()
    }
    
    //MARK: - Subviews
    
    private var searchTextField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray500)
                .font(.system(size: 15))
            
            TextField("მოძებნეთ შეთავაზებები...", text: $query)
                .font(.system(size: 14))
                .foregroundColor(.gray900)
                .submitLabel(.search)
            
            if !query.isEmpty {
                Button (action: {
                    query = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray500)
                        .font(.system(size: 15))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .frame(maxWidth: .infinity)
        .background(Color.gray100)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    
    private var filterButton: some View {
        Button(action: { onFilterTap?() }) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(isFilterActive ? .colorPrimary : .gray700)
                    .font(.system(size: 16, weight: .medium))
                    .frame(width: 46, height: 46)
                    .background(isFilterActive ? Color.colorPrimary.opacity(0.1) : Color.gray100)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                if isFilterActive {
                    Circle()
                        .fill(Color.colorPrimary)
                        .frame(width: 8, height: 8)
                        .offset(x: -4, y: 4)
                }
            }
        }
    }
}

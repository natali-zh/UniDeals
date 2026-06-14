//
//  HomeView.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 14.06.26.
//
//
//  HomeView.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 14.06.26.
//

import SwiftUI

struct HomeView: View {
    
    //MARK: - Properties
    
    @State private var query: String = ""
    
    //MARK: - Body
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                HomeSearchBar(query: $query)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
            }
            .background(Color(.systemGroupedBackground))
            //.padding()
        }
        .background(Color.white)
    }
}

#Preview {
    HomeView()
}


private struct HomeSearchBar: View {
    
    //MARK: - Properties
    
    @Binding var query: String
    
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
            
            TextField("Search discounts...", text: $query)
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
        Button (action: {}) {
            Image(systemName: "slider.horizontal.3")
                .foregroundColor(.gray700)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 46, height: 46)
                .background(Color.gray100)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

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

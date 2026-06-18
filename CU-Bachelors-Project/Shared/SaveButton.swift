//
//  SaveButton.swift
//  CU-Bachelors-Project
//

import SwiftUI

struct SaveButton: View {
    let isSaved: Bool
    var backgroundOpacity: Double = 0.25
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isSaved ? "heart.fill" : "heart")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSaved ? .red : .white)
                .padding(10)
                .background(Circle().fill(Color.black.opacity(backgroundOpacity)))
        }
    }
}

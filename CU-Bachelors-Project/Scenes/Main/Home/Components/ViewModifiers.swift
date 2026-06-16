//
//  ViewModifiers.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 17.06.26.
//

import SwiftUI

struct CardStyle: ViewModifier {
    var cornerRadius: CGFloat = 16
    var shadowOpacity: Double = 0.07
    var shadowRadius: CGFloat = 10
    var shadowYOffset: CGFloat = 3
    
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(shadowOpacity), radius: shadowRadius, x: 0, y: shadowYOffset)
    }
}

struct BadgeStyle: ViewModifier {
    var backgroundColor: Color = .colorPrimary
    var foregroundColor: Color = .white
    var fontSize: CGFloat = 13
    var horizontalPadding: CGFloat = 14
    var verticalPadding: CGFloat = 8
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize, weight: .bold))
            .foregroundColor(foregroundColor)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(Capsule().fill(backgroundColor))
    }
}

struct PillBackground: ViewModifier {
    var color: Color = .gray100
    var cornerRadius: CGFloat = 14
    
    func body(content: Content) -> some View {
        content
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

struct SectionTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 17, weight: .bold))
            .foregroundColor(.gray900)
    }
}

extension View {
    func cardStyle(
        cornerRadius: CGFloat = 16,
        shadowOpacity: Double = 0.07,
        shadowRadius: CGFloat = 10,
        shadowYOffset: CGFloat = 3
    ) -> some View {
        modifier(CardStyle(
            cornerRadius: cornerRadius,
            shadowOpacity: shadowOpacity,
            shadowRadius: shadowRadius,
            shadowYOffset: shadowYOffset
        ))
    }
    
    func badgeStyle(
        backgroundColor: Color = .colorPrimary,
        foregroundColor: Color = .white,
        fontSize: CGFloat = 13,
        horizontalPadding: CGFloat = 14,
        verticalPadding: CGFloat = 8
    ) -> some View {
        modifier(BadgeStyle(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            fontSize: fontSize,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding
        ))
    }
    
    func pillBackground(color: Color = .gray100, cornerRadius: CGFloat = 14) -> some View {
        modifier(PillBackground(color: color, cornerRadius: cornerRadius))
    }
    
    func sectionTitleStyle() -> some View {
        modifier(SectionTitleStyle())
    }
}

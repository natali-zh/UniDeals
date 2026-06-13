//
//  CustomLabel.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 13.06.26.
//


import UIKit

final class CustomLabel: UILabel {
    
    //MARK: - Properties
    
    private let labelText: String
    private let labelColor: UIColor
    private let labelFont: UIFont
    
    //MARK: - Init
    
    init(text: String, color: UIColor, font: UIFont) {
        self.labelText = text
        self.labelColor = color
        self.labelFont = font
        super.init(frame: .zero)
        setup(text: labelText, color: labelColor, font: labelFont)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setup(text: String, color: UIColor, font: UIFont) {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        self.text = text
        self.textColor = color
        self.font = font
    }
}

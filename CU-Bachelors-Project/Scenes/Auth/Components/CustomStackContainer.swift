//
//  CustomStackContainer.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 13.06.26.
//

import UIKit

class CustomStackContainer: UIView {
    
    //MARK: - Properties
    
    private let label: UILabel
    private let button: UIButton
    
    private lazy var labelButtonStack = {
        let stackView = UIStackView(arrangedSubviews: [label, button])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Init
    
    init(label: UILabel, button: UIButton) {
        self.label = label
        self.button = button
        super.init(frame: .zero)
        setupLoginStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setupLoginStack() {
        addSubview(labelButtonStack)
        NSLayoutConstraint.activate([
            labelButtonStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelButtonStack.topAnchor.constraint(equalTo: self.topAnchor),
            labelButtonStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

//
//  Textfield+UILabel_StackView.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 25.08.2022.
//

import Foundation
import UIKit

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}

class CustomStackView {
    
    var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var textfield: TextField = {
        let textfield = TextField()
        textfield.font = .systemFont(ofSize: 17)
        textfield.backgroundColor = .systemGray6
        textfield.layer.cornerRadius = 8.0
        textfield.textAlignment = .left
        return textfield
    }()
    
    var stackView = UIStackView()
    
    func setupElements(labelTitle title: String, textfieldPlaceholder placeholder: String? = nil, andAligment aligment: NSTextAlignment) {
        label.text = title
        textfield.textAlignment = aligment
        if let placeholder = placeholder {
            textfield.placeholder = placeholder
        }
    }
    
    func createStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 8
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(textfield)
        
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textfield.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        textfield.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
    }
    
    
}

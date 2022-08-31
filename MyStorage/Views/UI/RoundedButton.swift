//
//  UIButton.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 25.08.2022.
//

import Foundation
import UIKit

final class RoundedButton: UIButton {
    
    func configure(withTitle title: String) {
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 8
        self.titleLabel?.font = .systemFont(ofSize: 17)
        self.isEnabled = false
        self.backgroundColor = .systemGray5
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

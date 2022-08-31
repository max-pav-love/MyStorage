//
//  AppNameLabel.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 25.08.2022.
//

import Foundation
import UIKit

class AppNameLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = .preferredFont(forTextStyle: .largeTitle)
        self.text = "My Storage"
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

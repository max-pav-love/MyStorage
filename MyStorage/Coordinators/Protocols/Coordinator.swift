//
//  Coordinator.swift
//  MyStorage
//
//  Created by Максим Хлесткин on 24.08.2022.
//

import Foundation
import UIKit

protocol Coordinator {
    
    var navigationController: UINavigationController { get set }
    
    func start()
    
}

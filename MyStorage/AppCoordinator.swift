//
//  AppCoordinator.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 24.08.2022.
//

import UIKit
import FirebaseAuth

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
        
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard Auth.auth().currentUser != nil else {
            showLoginScreen()
            return
        }
        showStorageScreen()
    }
    
    func showLoginScreen() {
        let viewModel = LoginViewModel()
        let vc = LoginViewController(coordinator: self, viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showSMSVerificationViewController() {
        let viewModel = SMSVerificationViewModel()
        let vc = SMSVerificcationViewController(coordinator: self, viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showStorageScreen(path: String? = nil) {
        let viewModel = StorageViewModel(path: path)
        let vc = StorageViewController(coordinator: self, viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
}

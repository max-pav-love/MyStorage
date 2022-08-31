//
//  LoginViewModel.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 24.08.2022.
//

class LoginViewModel {
    
    enum Status {
        case inProgress
        case entered
    }
    
    var status = Dynamic(Status.inProgress)
    
    func changeButtonStateWith(_ phoneNumber: String) {
        guard phoneNumber.count == 12 else {
            status.value = .inProgress
            return
        }
        status.value = .entered
    }
    
    func getCodeButtonTapped(phoneNumber: String, completion: @escaping () -> ()) {
        AuthManager.shared.startAuth(phoneNumber: phoneNumber) { success in
            guard success else { return }
            completion()
        }
    }
    
}

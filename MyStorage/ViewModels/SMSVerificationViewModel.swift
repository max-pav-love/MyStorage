//
//  SMSVerificationViewModel.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 25.08.2022.
//

class SMSVerificationViewModel {
    
    enum Status {
        case idle
        case success(String)
        case failure(String)
    }
    
    var status = Dynamic(Status.idle)
    
    func verifySMSCode(code: String) {
        guard code.count == 6 else {
            status.value = .idle
            return
        }
        AuthManager.shared.verifyCode(smsCode: code) { [weak self] success in
            if success {
                self?.status.value = .success("You successfully logged in")
            } else {
                self?.status.value = .failure("Wrong code")
            }
        }
    }
    
}

//
//  LoginViewController.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 24.08.2022.
//

import UIKit

final class LoginViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel: LoginViewModel
    private weak var coordinator: AppCoordinator?
    
    // MARK: - UI
    
    var appLabel = AppNameLabel()
    var getCodeButton = RoundedButton()
    var loginStackView = CustomStackView()
    
    // MARK: - Init
    
    init(coordinator: AppCoordinator, viewModel: LoginViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        setupTextField()
        setupButton()
        setupConstraints()
        setupStackView()
    }
    
    // MARK: - ViewModel Bindings

    private func bindViewModel() {
        viewModel.status.bind { status in
            DispatchQueue.main.async {
                self.set(status: status)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func set(status: LoginViewModel.Status) {
        switch status {
        case .inProgress:
            getCodeButton.isEnabled = false
            getCodeButton.backgroundColor = .systemGray5
        case .entered:
            getCodeButton.isEnabled = true
            getCodeButton.backgroundColor = .systemCyan
        }
    }
    
    private func setupStackView() {
        loginStackView.setupElements(labelTitle: "Phone number", textfieldPlaceholder: "+791234567890", andAligment: .left)
        loginStackView.createStackView()
        loginStackView.textfield.delegate = self
    }
    
    private func setupButton() {
        getCodeButton.addTarget(self, action: #selector(getCodeButtonPressed(_:)),for: .touchUpInside)
        getCodeButton.configure(withTitle: "Get code")
    }
    
    private func setupTextField() {
        loginStackView.textfield.delegate = self
        loginStackView.textfield.addTarget(self,
            action: #selector(textFieldValueChanged(_:)),
            for: .editingChanged)
    }
    
    // MARK: - Handlers
    
    @objc
    private func textFieldValueChanged(_ sender: UITextField) {
        guard let phoneNumber = sender.text else { return }
        viewModel.changeButtonStateWith(phoneNumber)
    }
    
    @objc
    private func getCodeButtonPressed(_ sender: UIButton) {
        guard let phoneNumber = loginStackView.textfield.text else { return }
        viewModel.getCodeButtonTapped(phoneNumber: phoneNumber, completion: { [weak self] in
            self?.coordinator?.showSMSVerificationViewController()
        })
    }
    
    // MARK: - Layout
    
    private func setupConstraints() {
        view.addSubview(appLabel)
        view.addSubview(getCodeButton)
        view.addSubview(loginStackView.stackView)
        
        loginStackView.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            appLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            appLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            loginStackView.stackView.topAnchor.constraint(equalTo: appLabel.bottomAnchor, constant: 48),
            loginStackView.stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            loginStackView.stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            getCodeButton.topAnchor.constraint(equalTo: loginStackView.stackView.bottomAnchor, constant: 36),
            getCodeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 72),
            getCodeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -72),
            getCodeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
              let stringRange = Range(range, in: text) else {
            return false
        }
        
        let updatedText = text.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 12
    }
}

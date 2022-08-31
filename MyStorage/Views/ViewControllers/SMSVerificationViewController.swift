//
//  SMSVerificationViewController.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 25.08.2022.
//

import UIKit

final class SMSVerificcationViewController: UIViewController {

    // MARK: - Properties
    
    private weak var coordinator: AppCoordinator?
    private let viewModel: SMSVerificationViewModel
    
    // MARK: - UI
    
    var appLabel = AppNameLabel()
    var verificationStackView = CustomStackView()
    var statusLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    // MARK: - Init
    
    init(coordinator: AppCoordinator, viewModel: SMSVerificationViewModel) {
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
        setupTextfield()
        setupStackView()
        setupConstraints()
    }
    
    // MARK: - ViewModel Binding
    
    private func bindViewModel() {
        viewModel.status.bind { status in
            DispatchQueue.main.async {
                self.set(status: status)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupStackView() {
        verificationStackView.setupElements(labelTitle: "Enter your verification code (6 digits)", andAligment: .center)
        verificationStackView.createStackView()
    }
    
    private func setupTextfield() {
        verificationStackView.textfield.delegate = self
        verificationStackView.textfield.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func set(status: SMSVerificationViewModel.Status) {
        switch status {
        case .idle:
            statusLabel.text = ""
        case .success(let text):
            statusLabel.text = text
            statusLabel.textColor = .systemGreen
            verificationStackView.textfield.isEnabled = false
            openStorage()
        case .failure(let error):
            statusLabel.text = error
            statusLabel.textColor = .systemRed
        }
    }
    
    private func openStorage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.coordinator?.showStorageScreen()
            self.navigationController?.viewControllers.removeAll(where: {!($0 is StorageViewController)})
        }
    }
    
    // MARK: - Handlers
    
    @objc
    private func textFieldValueChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        viewModel.verifySMSCode(code: text)
    }
    
    // MARK: - Layout
    
    private func setupConstraints() {
        view.addSubview(appLabel)
        view.addSubview(verificationStackView.stackView)
        view.addSubview(statusLabel)
        
        verificationStackView.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            appLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            appLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            verificationStackView.stackView.topAnchor.constraint(equalTo: appLabel.bottomAnchor, constant: 48),
            verificationStackView.stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            verificationStackView.stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            statusLabel.topAnchor.constraint(equalTo: verificationStackView.stackView.bottomAnchor, constant: 36),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36)
        ])
    }
    
}

// MARK: - UITextFieldDelegate

extension SMSVerificcationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
              let stringRange = Range(range, in: text) else {
            return false
        }
        
        let updatedText = text.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 6
    }
}

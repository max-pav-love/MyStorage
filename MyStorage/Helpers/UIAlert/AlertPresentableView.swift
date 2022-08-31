//
//  AlertPresentableView.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 31.08.2022.
//

import UIKit

protocol AlertPresentableViewModel {
    var alertModel: Dynamic<AlertModel?> { get set }
}

protocol AlertPresentableView {
    associatedtype ModelType: AlertPresentableViewModel

    var viewModel: ModelType { get set }
}

extension AlertPresentableView where Self: UIViewController {
    func bindToAlerts() {
        viewModel.alertModel.bind { [weak self] model in
            guard let model = model else { return }
            DispatchQueue.main.async {
                let alert = AlertBuilder.buildAlertController(for: model)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

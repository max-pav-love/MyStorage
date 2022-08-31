//
//  StorageViewModel.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 26.08.2022.
//

import Foundation
import UIKit

class StorageViewModel: AlertPresentableViewModel {
    var itemPicker: ItemPickerManager?
    var documents: Dynamic<[File]> = .init([])
    var layoutMode: Dynamic<LayoutMode> = .init(.grid)
    var alertModel = Dynamic<AlertModel?>(nil)
    let path: String?
        
    init(path: String? = nil) {
        self.path = path
        loadLayoutMode()
    }
    
    func getData() {
        APIManager.shared.getList(for: path) { [weak self] result in
            switch result {
            case .success(let files):
                self?.documents.value = files
            case .failure(let error):
                self?.alertModel.value = AlertModel(
                    actionModels: [AlertModel.ActionModel.init(
                        title: "Cancel",
                        style: .cancel,
                        handler: nil)],
                    title: "Upload error" ,
                    message: error.localizedDescription,
                    prefferedStyle: .alert)
            }
        }
    }
    
    func upload(url: URL, folder: String? = nil) {
        APIManager.shared.upload(url: url, folder: folder) { [weak self] error in
            if error != nil {
            self?.alertModel.value = AlertModel(
                actionModels: [AlertModel.ActionModel.init(
                    title: "Cancel",
                    style: .cancel,
                    handler: nil)],
                title: "Upload error" ,
                message: error?.localizedDescription,
                prefferedStyle: .alert)
            } else {
                self?.alertModel.value = AlertModel(
                    actionModels: [AlertModel.ActionModel.init(
                        title: "OK",
                        style: .cancel,
                        handler: nil)],
                    title: "Upload finished" ,
                    message: "File uploaded successfully",
                    prefferedStyle: .alert)
                self?.getData()
            }
        }
    }
    
    func delete(url: URL) {
        APIManager.shared.delete(url: url) { [weak self] error in
            if error != nil {
                self?.alertModel.value = AlertModel(
                    actionModels: [AlertModel.ActionModel.init(
                        title: "Cancel",
                        style: .cancel,
                        handler: nil)],
                    title: "Deletion error" ,
                    message: error?.localizedDescription,
                    prefferedStyle: .alert)
            } else {
                self?.alertModel.value = AlertModel(
                    actionModels: [AlertModel.ActionModel.init(
                        title: "OK",
                        style: .cancel,
                        handler: nil)],
                    title: "Deletion completed" ,
                    message: "File deleted successfully",
                    prefferedStyle: .alert)
                self?.getData()
            }
        }
    }

    func download(url: URL) {
        APIManager.shared.download(url: url) { [weak self] result in
            switch result {
            case .success:
                self?.alertModel.value = AlertModel(
                    actionModels: [AlertModel.ActionModel.init(
                        title: "OK",
                        style: .cancel,
                        handler: nil)],
                    title: "Download completed",
                    message: "File downloaded successfully",
                    prefferedStyle: .alert)
            case .failure(let error):
                self?.alertModel.value = AlertModel(
                    actionModels: [AlertModel.ActionModel.init(
                        title: "Cancel",
                        style: .cancel,
                        handler: nil)],
                    title: "Download error" ,
                    message: error.localizedDescription,
                    prefferedStyle: .alert)
            }
        }
    }
    
    func changeLayout() {
        let rawLayoutMode = (layoutMode.value.rawValue + 1) % LayoutMode.allCases.count
        layoutMode.value = LayoutMode(rawValue: rawLayoutMode) ?? layoutMode.value
        saveLayoutMode()
    }
    
    private func saveLayoutMode() {
        UserDefaults.standard.set(layoutMode.value.rawValue, forKey: "layoutMode")
        UserDefaults.standard.synchronize()
    }
    
    private func loadLayoutMode() {
        let rawLayoutMode = UserDefaults.standard.integer(forKey: "layoutMode")
        if let layoutMode = LayoutMode(rawValue: rawLayoutMode) {
            self.layoutMode.value = layoutMode
        }
    }
    
    func setupPicker(folder: String?) {
        var fullPath = path
        if let folder = folder {
            fullPath = [path ?? "", folder].joined(separator: "/")
        }
        itemPicker = ItemPickerManager(folderName: fullPath)
        itemPicker?.delegate = self
    }

}

// MARK: - ItemPickerManagerDelegate

extension StorageViewModel: ItemPickerManagerDelegate {
    func upload(from url: URL) {
        upload(url: url)
    }
    
    func upload(from url: URL, to folder: String) {
        upload(url: url, folder: folder)
    }
    
    func reset() {
        itemPicker = nil
    }
    
    func showAlert(text: String) {
        self.alertModel.value = AlertModel(
            actionModels: [AlertModel.ActionModel.init(
                title: "Cancel",
                style: .cancel,
                handler: nil)],
            title: "Error",
            message: text,
            prefferedStyle: .alert)
    }
}

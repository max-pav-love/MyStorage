//
//  ItemPickerManager.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 30.08.2022.
//

import UIKit
import UniformTypeIdentifiers

protocol ItemPickerManagerDelegate: AnyObject {
    func upload(from url: URL)
    func upload(from url: URL, to folder: String)
    func reset()
    func showAlert(text: String)
}

class ItemPickerManager: NSObject, UINavigationControllerDelegate {
    
    private let SIZE_LIMIT = 20
    
    let folderName: String?
        
    weak var delegate: ItemPickerManagerDelegate?
    
    init(folderName: String?) {
        self.folderName = folderName
    }
    
    func presentImagePicker(from controller: UIViewController) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        controller.present(picker, animated: true)
    }
    
    func presentDocumentPicker(from controller: UIViewController) {
        var types: [UTType] = [.data]
        types = types.filter{ $0 != .text && $0 != .livePhoto }
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types)
        picker.delegate = self
        controller.present(picker, animated: true)
    }
    
    private func upload(from url: URL) {
        guard isValidSize(for: url) else {
            delegate?.showAlert(
                text: "Your file size is more than \(SIZE_LIMIT)mb")
            return
        }
        if let folder = folderName {
            delegate?.upload(from: url, to: folder)
        } else {
            delegate?.upload(from: url)
        }
    }
    
    private func isValidSize(for url: URL) -> Bool {
        guard let bytes = try? url.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).fileSize else {
            return false
        }
        let megabytes = bytes / (1_024 * 1_024)
        return megabytes < SIZE_LIMIT
    }
    
}

// MARK: - UIImagePickerControllerDelegate

extension ItemPickerManager: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let url = info[.imageURL] as? URL else {
            delegate?.reset()
            return
        }
        upload(from: url)
        delegate?.reset()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        delegate?.reset()
    }
}

// MARK: - UIDocumentPickerDelegate

extension ItemPickerManager: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
        delegate?.reset()
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        upload(from: url)
        delegate?.reset()
    }
}

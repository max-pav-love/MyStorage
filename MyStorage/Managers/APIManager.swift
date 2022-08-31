//
//  APIManager.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 25.08.2022.
//

import Foundation
import UIKit
import FirebaseStorage

class APIManager {
    
    static let shared = APIManager()
    
    private let storage = Storage.storage()
    
    private let mapper = Mapper()
    
    public func getList(for folder: String? = nil, completion: @escaping (Result<[File],Error>) -> ()) {
        guard let uid = AuthManager.shared.uid else { return }
        
        var storageRef = storage.reference().child("/\(uid)")
        if let folder = folder {
            storageRef = storage.reference().child("/\(folder)")
        }
        storageRef.listAll { result, error in
            if let error = error {
                completion(.failure(error))
                return
            } else {
                let files = self.mapper.map(items: result?.items ?? [])
                let folders = self.mapper.map(folders: result?.prefixes ?? [])
                
                let items = (files + folders).sorted(by: {$0.name < $1.name})
                
                completion(.success(items))
            }
        }
    }
    
    public func upload(url: URL, folder: String? = nil, completion: @escaping (Error?) -> ()) {
        guard let uid = AuthManager.shared.uid else { return }

        let reference = storage.reference()
        var pathRef = reference.child("/\(uid)/\(url.lastPathComponent)")
        
        // There is no public API to create a folder. Instead folders are auto-created as you add files to them.
        
        if let folder = folder {
            if folder.contains("\(uid)") {
                pathRef = reference.child("/\(folder)/\(url.lastPathComponent)")
            } else {
                pathRef = reference.child("/\(uid)/\(folder)/\(url.lastPathComponent)")
            }
        }
        
        pathRef.putFile(from: url) { result in
            switch result {
            case .success:
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    public func delete(url: URL, completion: @escaping (Error?) -> ()) {
        let reference = storage.reference()
        let pathRef = reference.child(url.path)
        
        pathRef.delete { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    public func download(url: URL, completion: @escaping (Result<URL,Error>) -> ()) {
        let reference = storage.reference()
        let pathRef = reference.child(url.path)
        
        let localDirectory = FileManager.default.getDownloadsDirectory().appendingPathComponent(url.lastPathComponent)
        
        pathRef.write(toFile: localDirectory) { result in
            switch result {
            case .success(let url):
                completion(.success(url))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

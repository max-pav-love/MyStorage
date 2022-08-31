//
//  Mapper.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 29.08.2022.
//

import FirebaseStorage

class Mapper {
    
    func map(items: [StorageReference]) -> [File] {
        items.map{
            File(path: $0.fullPath,
                 name: $0.name,
                 isDirectory: false,
                 type: getType(by:$0.name))
        }
    }
    
    func map(folders: [StorageReference]) -> [File] {
        folders.map {
            File(path: $0.fullPath,
                 name: $0.name,
                 isDirectory: true,
                 type: .folder)
        }
    }
    
    private func getType(by name: String) -> FileType {
        let fileExtension = name.fileExtension()
        
        if let type = FileType.Image(rawValue: fileExtension) {
            return .image(type)
        }
        
        if let type = FileType.Document(rawValue: fileExtension) {
            return .document(type)
        }
        
        return .other
    }
    
}

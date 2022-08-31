//
//  FileManager.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 28.08.2022.
//

import Foundation

extension FileManager {
    
    func getDownloadsDirectory() -> URL {
        let path = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
        return path[0]
    }
    
}

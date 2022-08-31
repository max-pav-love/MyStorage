//
//  String.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 29.08.2022.
//

import Foundation

extension String {
    
    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
    
    func encodeToURL() -> URL {
        let encodedString = self.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        let url = URL(string: encodedString ?? self)!
        return url
    }
    
}

//
//  FileType.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 29.08.2022.
//

enum FileType {
    
    enum Document: String, CaseIterable {
        case doc, file, pdf
    }
    
    enum Image: String, CaseIterable {
        case png, svg, jpeg, jpg
    }
    
    case image(Image)
    case document(Document)
    case folder
    case other
    
}

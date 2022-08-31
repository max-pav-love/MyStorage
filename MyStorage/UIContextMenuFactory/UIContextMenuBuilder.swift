//
//  UIContextMenuBuilder.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 26.08.2022.
//

import Foundation
import UIKit

protocol UIContextMenuBuilderProtocol {
    
    var document: File? { get set }
    
    var renameHandler: UIActionHandler? { get set }
    var deleteHandler: UIActionHandler? { get set }
    var downloadHandler: UIActionHandler? { get set }
    
    func build() throws -> UIMenu
    
}

class UIContextMenuBuilder : UIContextMenuBuilderProtocol {
    var document: File?
    
    var renameHandler: UIActionHandler?
    
    var deleteHandler: UIActionHandler?
    
    var downloadHandler: UIActionHandler?
    
    func build() -> UIMenu {
        
        typealias Factory = UIContextMenuFactory
        
        var firstMenuChildrens: [UIMenuElement] = []
        
        if let renameHandler = renameHandler {
            firstMenuChildrens.append(Factory.rename(renameHandler))
        }
        
        if let downloadHandler = downloadHandler {
            firstMenuChildrens.append(Factory.download(downloadHandler))
        }
        
        if let deleteHandler = deleteHandler {
            firstMenuChildrens.append(Factory.delete(deleteHandler))
        }
        
        return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: firstMenuChildrens)
    }
    
}

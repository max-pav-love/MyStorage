//
//  ContextMenuFactory.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 26.08.2022.
//

import Foundation
import UIKit

struct UIContextMenuFactory {
    
    static func rename(_ handler: @escaping UIActionHandler) -> UIAction {
        return UIAction(title: "Rename", image: UIImage(systemName: "pencil"), attributes: [], handler: handler)
    }
    
    static func delete(_ handler: @escaping UIActionHandler) -> UIAction {
        return UIAction(title: "Delete", image: UIImage(systemName: "trash")?.withTintColor(.red), attributes: [], handler: handler)
    }
    
    static func download(_ handler: @escaping UIActionHandler) -> UIAction {
        return UIAction(title: "Download", image: UIImage(systemName: "arrow.down.circle"), attributes: [], handler: handler)
    }

}

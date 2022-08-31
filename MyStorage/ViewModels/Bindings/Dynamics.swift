//
//  Dynamics.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 24.08.2022.
//

import Foundation

final class Dynamic<T> {
    
    typealias Listener = (T) -> Void
    private var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init (_ value: T) {
        self.value = value
    }
    
}

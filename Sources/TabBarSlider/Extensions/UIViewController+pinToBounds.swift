//
//  File.swift
//  
//
//  Created by Paul on 12/09/2023.
//

import UIKit

extension UIViewController {
    
    func pinToBounds(parent: UIView, subview: UIView) {
        
        NSLayoutConstraint.activate([
        
            subview.topAnchor.constraint(equalTo: parent.topAnchor),
            subview.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            subview.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
        ])
    }
}

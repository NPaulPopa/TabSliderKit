//
//  File.swift
//  
//
//  Created by Paul on 12/09/2023.
//

import UIKit

extension UIViewController {
    
    public func add(_ child: UIViewController, animated: Bool = false) {
        
        addChild(child)
        view.addSubview(child.view)
        child.view.alpha = 1
        
        child.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            child.view.topAnchor.constraint(equalTo: view.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        if animated {
            child.view.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
            
            UIView.animate(withDuration: 1.5) {
                child.view.transform = .identity // Slide the child view up
            }
        }
        child.didMove(toParent: self)
    }

    public func remove(_ child: UIViewController, animated: Bool) {
        guard child.parent != nil else {
            return
        }
        
        if !animated {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
            return
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            child.view.alpha = 0

         }) { _ in
             child.willMove(toParent: nil)
             child.view.removeFromSuperview()
             child.removeFromParent()
         }
   }
}

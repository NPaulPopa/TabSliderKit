//
//  File.swift
//  
//
//  Created by Paul on 24/09/2023.
//

import Foundation
import UIKit

public protocol ParentControllerProtocol: AnyObject {
    
    var screenSize: CGFloat { get }
    var transitionManager: TransitionManager! { get set }
    
    func setupTransitionCoordinator(playerViewController: MiniPlayerProtocol)
}

public extension ParentControllerProtocol {
    
    var screenSize: CGFloat {
        UIScreen.main.bounds.height
    }
    
    func setupTransitionCoordinator(playerViewController: MiniPlayerProtocol) {

        let noSafeAreaDevice = screenSize < 670
        let bottomInset: CGFloat = noSafeAreaDevice ? 62 : 27
        let withSafeAreaInset: CGFloat = 83 + bottomInset
        let withoutSafeAreInset: CGFloat = 49 + bottomInset

        let additionalBottomInset = noSafeAreaDevice ? withoutSafeAreInset : withSafeAreaInset
        
        playerViewController.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: additionalBottomInset, right: 0)

        transitionManager = TransitionManager(playerViewController: playerViewController)
    }
}

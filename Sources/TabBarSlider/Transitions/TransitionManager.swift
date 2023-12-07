//
//  File.swift
//  
//
//  Created by Paul on 12/09/2023.
//

import UIKit
import Combine

public enum SheetState: Equatable {
    case open
    case closed
    
    static prefix func !(_ state: SheetState) -> SheetState {
        return state == .open ? .closed : .open
    }
}

public class TransitionManager: NSObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    private weak var playerViewController: MiniPlayerProtocol!

    public lazy var panGestureRecognizer = createPanGestureRecognizer()
    public lazy var tapGestureRecognizer = createTapGestureRecognizer()
    private var runningAnimators = [UIViewPropertyAnimator]()
    private var state: SheetState = .closed
    
    private var totalAnimationDistance: CGFloat {
        
        guard let playerViewController = playerViewController else { return 0 }
      
        let animationDistance = playerViewController.view.bounds.height - playerViewController.view.safeAreaInsets.bottom +
            playerViewController.hiddenRootView.bounds.height - 0 //original
        
        return animationDistance
    }

    init(playerViewController: MiniPlayerProtocol) {
        
        self.playerViewController = playerViewController
        super.init()
        
        playerViewController.view.addGestureRecognizer(panGestureRecognizer)
        playerViewController.view.addGestureRecognizer(tapGestureRecognizer)
        updateUI(with: state)
        
        subscribeToNotificationCenterPublisher()
    }
}

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


// MARK: Tap and Pan gestures handling
extension TransitionManager {

    @objc private func didPanPlayer(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            let translationY = recognizer.translation(in: playerViewController.view).y
            
            if !(translationY > 0 && state == .closed) {
                startInteractiveTransition(for: !state)
            }

        case .changed:
            
            let translation = recognizer.translation(in: recognizer.view!)
            
            if !(state == .closed && translation.y < 0) {
                updateInteractiveTransition(distanceTraveled: translation.y)
            }

        case .ended:
            let velocity = recognizer.velocity(in: recognizer.view!).y
            
            
            let isCancelled = isGestureCancelled(with: velocity)
            let translation = recognizer.translation(in: recognizer.view).y
            
            continueInteractiveTransition(cancel: isCancelled)
            
            if translation < 0 && !isCancelled && state == .open {
                NotificationCenter.default.post(name: .didChangeSheetState, object: state)
            }
            
            guard translation > 0 && !isCancelled else { return }
            
            NotificationCenter.default.post(name: .didChangeSheetState, object: state)
            //MARK: Baselined and tested
            playerViewController.miniPlayerView.invalidateIntrinsicContentSize()

        case .cancelled:
            
            continueInteractiveTransition(cancel: true)

        case .failed:
            continueInteractiveTransition(cancel: true)
        default:
            break
        }
    }

    @objc private func didTapPlayer(recognizer: UITapGestureRecognizer) {
        animateTransition(for: !state)
        if state == .closed {
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) { [weak self] in
                guard let self = self else { return }
            }
            NotificationCenter.default.post(name: .didChangeSheetState, object: state)
        } else {
            NotificationCenter.default.post(name: .didChangeSheetState, object: state)
        }
    }

    // Starts transition and pauses on pan .begin
    private func startInteractiveTransition(for state: SheetState) {
        animateTransition(for: state)
        runningAnimators.pauseAnimations()
    }

    // Scrubs transition on pan .changed
    private func updateInteractiveTransition(distanceTraveled: CGFloat) {
        var fraction = distanceTraveled / totalAnimationDistance
        if state == .open { fraction *= -1 }
        runningAnimators.fractionComplete = fraction
    }

    // Continues or reverse transition on pan .ended
    private func continueInteractiveTransition(cancel: Bool) {
        if cancel {
            runningAnimators.reverse()
            state = !state
        }

        runningAnimators.continueAnimations()
    }

    // Perform all animations with animators
    private func animateTransition(for newState: SheetState) {
        state = newState
        runningAnimators = createTransitionAnimators(with: TransitionManager.animationDuration)
        runningAnimators.startAnimations()
    }
    
    private func animateCloseTransition(for newState: SheetState) {
        state = newState
        runningAnimators = createCloseTransitionAnimators(with: TransitionManager.animationDuration)
        runningAnimators.startAnimations()
    }

    // Check if gesture is cancelled (reversed)
    private func isGestureCancelled(with velocity: CGFloat) -> Bool {
        guard velocity != 0 else { return false }

        let isPanningDown = velocity > 0
        return (state == .open && isPanningDown) || (state == .closed && !isPanningDown)
    }
}

//MARK: - GestureRecognizer Delegate

extension TransitionManager: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer else { return runningAnimators.isEmpty }

        guard let miniPlayerView = playerViewController.miniPlayerView,
            let closeButton = playerViewController.closeButton,
            let view = playerViewController.view else { return false }

        let tapLocation = tapGestureRecognizer.location(in: view)
        let closeButtonFrame = closeButton.convert(closeButton.frame, to: view).insetBy(dx: -8, dy: -8)
        
        return runningAnimators.isEmpty && (miniPlayerView.frame.contains(tapLocation) || closeButtonFrame.contains(tapLocation))
    }

    private func createPanGestureRecognizer() -> UIPanGestureRecognizer {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(didPanPlayer(recognizer:)))
        recognizer.delegate = self
        return recognizer
    }

    private func createTapGestureRecognizer() -> UITapGestureRecognizer {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(didTapPlayer(recognizer:)))
        recognizer.delegate = self
        return recognizer
    }
}

// MARK: Animators
extension TransitionManager {

    private static let animationDuration = TimeInterval(0.7)

    private func createTransitionAnimators(with duration: TimeInterval) -> [UIViewPropertyAnimator] {
        switch state {
        case .open:
            return [
                openPlayerAnimator(with: duration),
                fadeInPlayerAnimator(with: duration),
                fadeOutMiniPlayerAnimator(with: duration)
            ]
        case .closed:
            return [
                closePlayerAnimator(with: duration),
                fadeOutPlayerAnimator(with: duration),
                fadeInMiniPlayerAnimator(with: duration),
            ]
        }
    }
    
    private func createCloseTransitionAnimators(with duration: TimeInterval) ->
    [UIViewPropertyAnimator] {
        switch state {
        case .open:
            return [
                openPlayerAnimator(with: duration),
                fadeInPlayerAnimator(with: duration),
                fadeOutMiniPlayerAnimator(with: duration)
            ]
        case .closed:
            return [
                closePlayerAnimator(with: duration),
                fadeOutAndClosePlayerAnimator(with: duration),
                fadeInMiniPlayerAnimator(with: duration),
            ]
        }
    }

    private func openPlayerAnimator(with duration: TimeInterval) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1.0)
        addAnimation(to: animator, animations: {
            self.updatePlayerContainer(with: self.state)
            self.updateTabBar(with: self.state)
        })
        return animator
    }
    
    private func fadeInPlayerAnimator(with duration: TimeInterval) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn)
        addKeyframeAnimation(to: animator, withRelativeStartTime: 0.0, relativeDuration: 0.5) {
            self.updateTitleView(with: self.state)

            self.updatePlayer(with: self.state)
        }
        animator.scrubsLinearly = false
        return animator
    }
    
    private func fadeInMiniPlayerAnimator(with duration: TimeInterval) -> UIViewPropertyAnimator { // no issues here
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn)
        addKeyframeAnimation(to: animator, withRelativeStartTime: 0.0, relativeDuration: 0.5) {
            self.updateMiniPlayer(with: self.state)
        }
        animator.scrubsLinearly = false
        return animator
    }

    private func fadeOutMiniPlayerAnimator(with duration: TimeInterval) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut)
        addKeyframeAnimation(to: animator, withRelativeStartTime: 0.16, relativeDuration: 0.5) {
            self.updateMiniPlayer(with: self.state)
        }
        animator.scrubsLinearly = false
        return animator
    }

    private func closePlayerAnimator(with duration: TimeInterval) ->  UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.9)
        addAnimation(to: animator, animations: {
            self.updatePlayerContainer(with: self.state)
            self.updateTabBar(with: self.state)
        })
        return animator
    }
}

//
//  File.swift
//  
//
//  Created by Paul on 13/09/2023.
//

import UIKit
import Combine
import Extensions
import MiniItemBasket
import FloatingButton

protocol HomeViewControllerProtocol: AnyObject {
    
    func shouldAddChildViewController(parent: UIViewController)
    func shouldRemoveChildViewController(parent: UIViewController)
}

class HomeViewController: ProgrammaticViewController, FloatingButtonViewControllerProtocol {
    
    weak var delegate: HomeViewControllerProtocol?
                
    lazy var floatingTableView: FloatingButtonScrollViewProtocol = FloatingButtonTableView()
        
    var capsuleFloatingButton: UIView!
    
    override var childForStatusBarHidden: UIViewController? {
        let child = children.last
        return child
    }
    override var prefersStatusBarHidden: Bool { true }
    private var cancellables = Set<AnyCancellable>()
        
    init(){
        super.init(nibName: nil, bundle: nil)
        setupFloatingButton()
    }
    
    override func configure() {
        title = "Home"
                
        subscribeToTransitionPublisher()
        subscribeToNotificationCenterPublisher()
    }
    
    override func constrain() {

        addConstrainedSubview(floatingTableView)
        pinToBounds(parent: view, subview: floatingTableView)

        //TODO: - Include the lines below inside HomeCollectionViewController
        constrainFloatingButton()
        delegate?.shouldAddChildViewController(parent: self)
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.setNeedsLayout()
    }
    
    private func removeMiniPlayer() {
        delegate?.shouldRemoveChildViewController(parent: self)
    }
    
    private func addMiniPlayer() {
        delegate?.shouldAddChildViewController(parent: self)
    }
    
    private func subscribeToNotificationCenterPublisher() {
        
        NotificationCenter.default.publisher(for: .miniPlayerCloseButtonTapped)
            .sink { [weak self] _ in
                self?.removeMiniPlayer()
            }.store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .addItemsFloatingButtonTapped)
            .sink { [weak self] _ in
                self?.addMiniPlayer()

            }.store(in: &cancellables)
    }
}



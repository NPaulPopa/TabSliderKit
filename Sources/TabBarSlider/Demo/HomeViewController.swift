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
    
    private func subscribeToTransitionPublisher() {
                
        NotificationCenter.default.publisher(for: .didChangeSheetState)
            .compactMap { $0.object as? SheetState }
            .sink { [weak self] state in
                                
                guard let self = self else { return }
                
                switch state {
                case .open:

                    UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut) {

                        self.navigationController?.navigationBar.alpha = 0
                        self.navigationController?.navigationBar.isHidden = true
                        self.navigationController!.view.setNeedsLayout()
                    }
                case .closed:
                    UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut) {
                        self.navigationController?.navigationBar.alpha = 1
                        self.navigationController?.navigationBar.isHidden = false
                    }
                }
                
            }.store(in: &cancellables)
    }
}



//
//  File.swift
//  
//
//  Created by Paul on 13/09/2023.
//


import UIKit
import Combine
import FloatingButton

class NewTabBarViewController: UITabBarController, TabControllerProtocol {
    
    //MARK: - Properties
    
//    let factory = AddItemsFactory()
    
    public var coordinator: TransitionManager!
    public var customTabBar: UITabBar!
    public var tabBarContainer: UIView!
    public var shouldHideStatusBar: Bool = false
    
    public lazy var playerViewController: MiniPlayerProtocol! = DemoViewController()
    //factory.createAddItemsViewController()
    
    let homeViewController = HomeViewController()
    
    lazy var homeVC = UINavigationController(rootViewController: homeViewController)
    
    let chatVC = UINavigationController(rootViewController: UIViewController())
    let searchVC = UINavigationController(rootViewController: UIViewController())
    let leafVC = UINavigationController(rootViewController: UIViewController())

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupTabs()
        
        homeViewController.delegate = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTransitionCoordinator()
    }
}

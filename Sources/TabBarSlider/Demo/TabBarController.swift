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
    
    public lazy var playerViewController: MiniPlayerProtocol! = DemoChildViewController()
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


//MARK: - TabBar Configuration

extension NewTabBarViewController {
        
    private func setupTabs() {
        
        let homeTabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        let chatTabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "paperplane"), tag: 1)
        let searchTabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        
        let leafTabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "leaf"), tag: 3)
        
        homeVC.tabBarItem = homeTabBarItem
        homeVC.topViewController?.title = "Home"
        view.backgroundColor = .systemGray6
        
        chatVC.tabBarItem = chatTabBarItem
        chatVC.view.backgroundColor = .systemGray5
        chatVC.topViewController?.title = "Chat"
        
        searchVC.tabBarItem = searchTabBarItem
        searchVC.view.backgroundColor = .systemGray4
        searchVC.topViewController?.title = "Search"
        
        leafVC.tabBarItem = leafTabBarItem
        leafVC.view.backgroundColor = .systemGray4
        leafVC.topViewController?.title = "Green"
        
        viewControllers = [homeVC,chatVC,searchVC,leafVC]
        self.selectedIndex = 0
        
        customTabBar.items = [homeTabBarItem,chatTabBarItem,searchTabBarItem,leafTabBarItem]
    }
    
    //MARK: - Constraints
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        switch true {
            
        case item.title == "Home":
            selectedViewController = homeVC
        case item.title == "Chat":
            selectedViewController = chatVC
        case item.title == "Search":
            selectedViewController = searchVC
        case item.title == "Green":
            selectedViewController = leafVC
        default:
            break
        }
    }
}

extension NewTabBarViewController: HomeViewControllerProtocol {
    
    func shouldAddChildViewController(parent: UIViewController) {
        parent.add(playerViewController, animated: false)
    }
    
    func shouldRemoveChildViewController(parent: UIViewController) {
        parent.remove(playerViewController, animated: true)
    }
}

class DemoChildViewController: UIViewController, MiniPlayerProtocol {
    
    var closeButton: UIButton! = UIButton()
    
    var titleView: UILabel = UILabel()
    
    var addItemsMainView: UIView!
    
    var hiddenRootView: UIView! = UIView()
    
    lazy var miniPlayerView: UIView! = {
        let view = UIView()
        view.backgroundColor = .systemPink
        return view
    }()
}

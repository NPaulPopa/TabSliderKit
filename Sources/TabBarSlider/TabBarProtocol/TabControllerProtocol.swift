//
//  File.swift
//  
//
//  Created by Paul on 12/09/2023.
//

import UIKit

///UITabBarController subclasses should adopt this protocol when displaying a TabBar overlay that can be expanded using a TransitionCoordinator
/// - STEP 1 - Call setupTabBar() inside `viewDidLoad()`
/// ```
/// class TabBarViewController: TabControllerProtocol {
///
/// override func viewDidLoad() {
///     super.viewDidLoad()
///         setupTabBar()
///     }
/// }
/// ```
/// -  STEP 2 - Call setupTransitionCoordinator() inside `viewDidAppear()`
/// ```
/// override func viewDidAppear(_ animated: Bool) {
///      super.viewDidAppear(animated)
///         setupTransitionCoordinator()
///     }
/// }
/// ```
public protocol TabControllerProtocol: UITabBarController  {
    
    var tabBar: UITabBar { get }
    var customTabBar: UITabBar! { get set }
    var tabBarContainer: UIView! { get set }
    var shouldHideStatusBar: Bool { get set }
    var playerViewController: MiniPlayerProtocol! { get set }
    var coordinator: TransitionManager! { get set }
    
    ///Call this method inside `viewDidLoad()` to ensure that customTabBar has been properly constrained
    func setupTabBar()
    
    ///Call this method inside`viewDidAppear(_:)` to ensure that customTabBar has been given a frame
    func setupTransitionCoordinator()
    
    ///Override this method to provide a custom appearance for the TabBarController's customTabBar
    /// - Default value of customTabBar's appearance is set to: .systemChromeMaterial
    func configureTabBarAppearance()
}

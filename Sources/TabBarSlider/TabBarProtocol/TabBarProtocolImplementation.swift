//
//  File.swift
//  
//
//  Created by Paul on 12/09/2023.
//

import UIKit

public extension TabControllerProtocol {
    
    func setupTabBar() {
        
        customTabBar = CustomTabBar()
        tabBarContainer = TabBarContainerView()
        
        tabBar.isHidden = true
        customTabBar.delegate = self

        constrainCustomTabBar()
        configureTabBarAppearance()
    }
    
    func setupTransitionCoordinator() {
        let tabBarBottomSafeAreaInset = customTabBar.safeAreaInsets.bottom
        let bottomInset: CGFloat = tabBarBottomSafeAreaInset == 0 ? 62 : 27
        let additionalBottomInset = customTabBar.bounds.height + bottomInset
        
        playerViewController.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: additionalBottomInset, right: 0)

        coordinator = TransitionManager(tabBarViewController: self, playerViewController: playerViewController)
    }
    
    func constrainCustomTabBar() {
                        
        tabBarContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBarContainer)

        NSLayoutConstraint.activate([
        
            tabBarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBarContainer.heightAnchor.constraint(equalTo: tabBar.heightAnchor)
        ])
        
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBarContainer.addSubview(customTabBar)
        pinToBounds(parent: tabBarContainer, subview: customTabBar)
        
        view.bringSubviewToFront(tabBarContainer)
    }
    
    func configureTabBarAppearance() {
        
        let appearance = UITabBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        customTabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            customTabBar.scrollEdgeAppearance = appearance
        } else { }
    }
}

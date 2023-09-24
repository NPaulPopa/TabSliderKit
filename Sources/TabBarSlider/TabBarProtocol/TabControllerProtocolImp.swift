//
//  File.swift
//  
//
//  Created by Paul on 12/09/2023.
//

import UIKit

public extension TabControllerProtocol {
    
    var screenSize: CGFloat {
        UIScreen.main.bounds.height
    }
    
    func setupTabBar() {
        
        customTabBar = CustomTabBar()
        tabBarContainer = TabBarContainerView()
        
        tabBar.isHidden = true
        customTabBar.delegate = self

        constrainCustomTabBar()
        configureTabBarAppearance()
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

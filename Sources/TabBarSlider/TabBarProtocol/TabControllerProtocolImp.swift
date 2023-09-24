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
    
    func setupTransitionCoordinator() {
        
       // let tabBarBottomSafeAreaInset = customTabBar.safeAreaInsets.bottom
     //  let bottomInset: CGFloat = tabBarBottomSafeAreaInset == 0 ? 62 : 27
     //   let additionalBottomInset = customTabBar.bounds.height + bottomInset
        
        let noSafeAreaDevice = screenSize < 670
        let bottomInset: CGFloat = noSafeAreaDevice ? 62 : 27
        let withSafeAreaInset: CGFloat = 83 + bottomInset
        let withoutSafeAreInset: CGFloat = 49 + bottomInset

        let additionalBottomInset = noSafeAreaDevice ? withoutSafeAreInset : withSafeAreaInset
        
        playerViewController.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: additionalBottomInset, right: 0)

        //TODO: - `The following actions
        /*
         1. Remove tabBarViewController dependency from TransitionManager
         
         2. Pass playerViewController into setupTransitionCoordinator
         - I need to find a way to provide the customTabBar's bounds or bottom SafeArea insets in order to add the bottom offset as UIEdgInsets on the playerViewController
         
         - The goal is to remove the playerViewController and coordinator dependency so that this extension and its corresponding protocol is only responsible for adding a custom tab bar and a custom container
         
         - The object who knows about both the coordinator and the playerViewController should be the object that presents the playerViewController
         */
        coordinator = TransitionManager(playerViewController: playerViewController)
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

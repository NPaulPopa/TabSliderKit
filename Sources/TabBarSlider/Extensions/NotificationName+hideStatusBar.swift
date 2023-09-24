//
//  File.swift
//  
//
//  Created by Paul on 24/09/2023.
//

import Foundation

public extension Notification.Name {
    
    ///This notification is sent whenever the MiniPlayer is changing its state from .closed to .opened and vice-versa
    ///
    ///```
    ///  func subscribeToNotifications() {
    ///    NotificationCenter.default.publisher(for: .shouldHideStatusBar)
    ///        .compactMap { $0.object as? SheetState }
    ///        .sink { [weak self] sheetState in
    ///            self?.tabBarViewController.shouldHideStatusBar = sheetState == .open
    ///            self?.tabBarViewController.setNeedsStatusBarAppearanceUpdate()
    ///        }
    ///        .store(in: &cancellables)
    /// }
    ///```
    /// - Subscribe to this notification for updating the statusBar between shown and hidden
    ///
    static let shouldHideStatusBar = Notification.Name("ShouldHideStatusBarNotification")
}


//
//  File.swift
//  
//
//  Created by Paul on 12/09/2023.
//

import Foundation

public extension Notification.Name {
    
    static let didChangeSheetState = Notification.Name("DidChangeSheetStateNotification")
    
    static let closeAndRemoveController = Notification.Name("CloseAndRemoveControllerNotification")    
}

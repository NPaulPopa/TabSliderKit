//
//  File.swift
//  
//
//  Created by Paul on 12/09/2023.
//

import UIKit

public protocol MiniPlayerProtocol: UIViewController {
    
    var closeButton: UIButton! { get set  }
    var titleView: UILabel { get }
    var addItemsMainView: UIView! { get }
    var hiddenRootView: UIView! { get set }
    var miniPlayerView: UIView! { get set  }
}

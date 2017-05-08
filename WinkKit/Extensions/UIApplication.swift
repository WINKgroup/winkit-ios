//
//  UIApplication.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 08/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

public extension UIApplication {
    
    /// Return the current most visibile `UIViewController`. It can be useful when you need to know
    /// what is the most visibile viewController even when the scope doesn't know anything about view hierarchy.
    public class func wk_topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return wk_topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return wk_topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return wk_topViewController(controller: presented)
        }
        return controller
    }
    
}

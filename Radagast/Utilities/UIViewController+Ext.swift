//
//  UIViewController+Ext.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import Foundation
import UIKit

@nonobjc extension UIViewController {
    
    /// Function for viewControllers to add child to their hierarchy
    /// - Parameters:
    ///   - child: UIViewController to be embedded in parent
    ///   - frame: CGRect for positioning child view in parent
    ///   - constraints: [NSLayoutConstraint] for positioning child view in parent.
    func add(_ child: UIViewController, frame: CGRect? = nil, constraints: [NSLayoutConstraint]? = nil) {
        addChild(child)
        // If no autolayout will be used
        if let frame = frame {
            child.view.frame = frame
        }

        view.addSubview(child.view)
        
        // If building with autolayout
        if let constraints = constraints {
            child.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(constraints)
        }
        child.didMove(toParent: self)
    }
    
    
    /// Remove viewController from parentViewController
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

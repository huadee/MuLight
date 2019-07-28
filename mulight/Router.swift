//
//  Router.swift
//  mulight
//
//  Created by jukui liu on 2019/7/28.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import Foundation
import UIKit

public class Router: NSObject {
    private var completions: [UIViewController: () -> Void]
    private let navigationController: UINavigationController
    
    public init(_ navigation: UINavigationController = UINavigationController()) {
        self.completions = [:]
        self.navigationController = navigation
        super.init()
        self.navigationController.delegate = self
    }
    
    func runCompletion(_ controller: UIViewController) {
        completions[controller]?()
        completions.removeValue(forKey: controller)
    }
}

extension Router: Routable {
    public func push(_ module: ViewPresentable, animated: Bool, onPop: (() -> Void)?) {
        let controller = module.toPresentable()
        if let onPop = onPop {
            completions[controller] = onPop
        }
        navigationController.pushViewController(controller, animated: animated)
    }
}

extension Router: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        runCompletion(viewController)
    }
}

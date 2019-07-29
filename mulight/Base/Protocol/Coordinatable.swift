//
//  Coordinatable.swift
//  mulight
//
//  Created by jukui liu on 2019/7/28.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import Foundation

public protocol Coordinatable: class {
    func start()
    var childCoordinators: [Coordinatable] { set get }
}

public extension Coordinatable {
    func addChildCoordinator(_ coordinator: Coordinatable) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinatable) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

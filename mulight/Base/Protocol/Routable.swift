//
//  Routable.swift
//  mulight
//
//  Created by jukui liu on 2019/7/28.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import Foundation
import UIKit

public protocol Routable: class {
    func push(_ module: ViewPresentable, animated: Bool, onPop:(() -> Void)?)
    func present(_ module: ViewPresentable, animated: Bool)
}

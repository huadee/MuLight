//
//  Presentable.swift
//  mulight
//
//  Created by jukui liu on 2019/7/28.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import Foundation
import UIKit

public protocol ViewPresentable: class {
    func toPresentable() -> UIViewController
}

extension UIViewController: ViewPresentable {
    public func toPresentable() -> UIViewController {
        return self
    }
}

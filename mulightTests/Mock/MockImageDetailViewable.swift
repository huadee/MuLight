//
//  MockImageDetailViewable.swift
//  mulightTests
//
//  Created by jukui liu on 7/30/19.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
@testable import mulight

class MockImageDetailViewable: ImageDetailViewable {
    var imageCalled = false
    func image() -> Observable<UIImage> {
        imageCalled = true
        return Observable.just(UIImage())
    }
}

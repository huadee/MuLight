//
//  MockHomeViewable.swift
//  mulightTests
//
//  Created by jukui liu on 2019/7/29.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import Foundation
import RxSwift
@testable import mulight

class MockHomeViewable: HomeViewable {
    func saveImage(_ image: Data, _ name: String) -> Observable<Bool> {
        return Observable.just(true)
    }
}

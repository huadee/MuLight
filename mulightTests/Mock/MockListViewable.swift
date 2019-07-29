//
//  MockListViewable.swift
//  mulightTests
//
//  Created by jukui liu on 7/30/19.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import Foundation
import RxSwift
@testable import mulight

class MockListViewable: ListViewable {
    var imageCalled = false
    func image(_ index: Int) -> ImageModel {
        imageCalled = true
        return ImageModel.init(name: "name", filePath: "path", createTime: 123)
    }
    
    var refreshDataCalled = false
    func refreshData() -> Observable<[ImageModel]> {
        refreshDataCalled = true
        return Observable.just([])
    }
    
    var dataSource: [ImageModel] = []
}

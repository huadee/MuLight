//
//  MockImageServiceable.swift
//  mulightTests
//
//  Created by jukui liu on 7/30/19.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import Foundation
import RxSwift
@testable import mulight

class MockImageServiceable: ImageServiceable {
    var saveCalled = false
    func save(_ image: Data, _ name: String, _ time: Double) -> Observable<Bool> {
        saveCalled = true
        return Observable.just(true)
    }
    
    var loadImageCalled = false
    func loadImage(_ path: String) -> Observable<Data> {
        loadImageCalled = true
        return Observable.just(Data())
    }
    
    var fetchImageListCalled = false
    func fetchImageList() -> Observable<ImageList> {
        fetchImageListCalled = true
        return Observable.just(ImageList(data: [ImageModel(name: "name", filePath: "path", createTime: 123)]))
    }
}

//
//  ListViewModel.swift
//  mulight
//
//  Created by jukui liu on 7/29/19.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import Foundation
import RxSwift

protocol ListViewable: class {
    func image(_ index: Int) -> ImageModel
    func refreshData() -> Observable<[ImageModel]>
    var dataSource: [ImageModel] { set get }
}

class ListViewModel: NSObject {
    private let disposeBag = DisposeBag()
    private let imageService: ImageServiceable
    
    var dataSource: [ImageModel] = []
    
    init(_ imageService: ImageServiceable = ImageService.sharedInstance) {
        self.imageService = imageService
        super.init()
    }
}

extension ListViewModel: ListViewable {
    func image(_ index: Int) -> ImageModel {
        guard index < dataSource.count else {
            return ImageModel(name: "", filePath: "", createTime: 0)
        }
        return dataSource[index]
    }
    
    func refreshData() -> Observable<[ImageModel]> {
        let listObservable = imageService.fetchImageList()
        listObservable.subscribe(onNext: {
            self.dataSource = $0.data
        }).disposed(by: disposeBag)
        return listObservable.map( {$0.data})
    }
}

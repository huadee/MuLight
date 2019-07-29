//
//  HomeViewModel.swift
//  mulight
//
//  Created by jukui liu on 2019/7/28.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeViewable: class {
    func saveImage(_ image: Data, _ name: String) -> Observable<Bool>
}

class HomeViewModel: NSObject {
    private let disposeBag = DisposeBag()
    private let imageService: ImageServiceable
    
    init(_ imageService: ImageServiceable = ImageService()) {
        self.imageService = imageService
        super.init()
    }    
}

extension HomeViewModel: HomeViewable {
    func saveImage(_ image: Data, _ name: String) -> Observable<Bool> {
        return imageService.save(image, name, Date().timeIntervalSince1970)
    }
}

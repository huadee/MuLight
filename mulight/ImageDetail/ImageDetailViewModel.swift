//
//  ImageDetailViewModel.swift
//  mulight
//
//  Created by jukui liu on 7/29/19.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

protocol ImageDetailViewable: class {
    func image() -> Observable<UIImage>
}

class ImageDetailViewModel: NSObject {
    private let disposeBag = DisposeBag()
    private let imageService: ImageServiceable
    
    private let imagePath: String

    init(_ imageService: ImageServiceable = ImageService.sharedInstance, imagePath: String) {
        self.imageService = imageService
        self.imagePath = imagePath
        super.init()
    }
}

extension ImageDetailViewModel: ImageDetailViewable {
    
    func image() -> Observable<UIImage> {
        let imageSubject = PublishSubject<UIImage>()
        imageService.loadImage(imagePath)
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (data) in
                guard let image = UIImage(data: data) else {
                    imageSubject.onNext(UIImage())
                    imageSubject.onCompleted()
                    return
                }
                imageSubject.onNext(image)
                imageSubject.onCompleted()
        }).disposed(by: disposeBag)
        return imageSubject.asObservable()
    }
}

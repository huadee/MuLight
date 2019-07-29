//
//  ImageTableViewCell.swift
//  mulight
//
//  Created by jukui liu on 7/29/19.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class ImageTableViewCell: UITableViewCell {
    private let disposeBag = DisposeBag()
    
    private var thumbImageSubject: PublishSubject<UIImage>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func prepareForReuse() {
        thumbImageSubject?.onCompleted()
        super.prepareForReuse()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        // ToDo - may changed
    }
    
    public func update(_ data: ImageModel) {
        self.textLabel?.text = data.name
        self.generateTime(data.createTime).observeOn(MainScheduler.instance)
            .subscribe(onNext: { (text) in
            self.detailTextLabel?.text = text
        }).disposed(by: disposeBag)
        
        thumbImageSubject = self.thumbImage(data.filePath, CGSize(width: 60, height: 60))
        thumbImageSubject?.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (image) in
                self.imageView?.image = image
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }).disposed(by: disposeBag)
    }
    
    // MARK: - helper
    // TODO - refactor
    func generateTime(_ time: Double) -> Observable<String> {
        return Observable.create({ (observer) -> Disposable in
            let date = Date(timeIntervalSince1970: time)
            observer.onNext("\(date)")
            observer.onCompleted()
            return Disposables.create()
        }).subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func thumbImage(_ path: String, _ targetSize: CGSize) -> PublishSubject<UIImage> {
        let resultSubject = PublishSubject<UIImage>()
        let imageObservable = ImageService.sharedInstance.loadImage(path)
        imageObservable.observeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (data) in
                guard let image = UIImage(data: data),
                let thumb = self.resizeImage(image: image, targetSize: targetSize)else {
                    resultSubject.onNext(UIImage())
                    resultSubject.onCompleted()
                    return
                }
                resultSubject.onNext(thumb)
                resultSubject.onCompleted()
        }).disposed(by: disposeBag)
        return resultSubject
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

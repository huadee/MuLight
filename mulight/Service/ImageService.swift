//
//  ImageService.swift
//  mulight
//
//  Created by jukui liu on 2019/7/29.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import Foundation
import RxSwift
import CryptoSwift

public protocol ImageServiceable {
    func save(_ image: Data, _ name: String, _ time: Double) -> Observable<Bool>
    func loadImage(_ path: String) -> Observable<Data>
    func fetchImageList() -> Observable<ImageList>
}

class ImageService: NSObject {
    private let disposeBag = DisposeBag()
    private let fileManager: FileManager
    
    static let sharedInstance = ImageService()
    
    private lazy var imageJsonFilePath: String = {
        guard let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first else {
            return ""
        }
        return  dir + "/images.json"
    }()

    private lazy var imageDirectoryPath: String = {
        guard let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first else {
            return ""
        }
        return  dir + "/images"
    }()

    init(_ fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    // MARK: - helpers
    func addImageJson(_ path: String, _ model: ImageModel) -> Observable<Bool> {
        let result: ReplaySubject<Bool> = ReplaySubject.create(bufferSize: 1)
        
        let checkJsonFileObservable = checkImageJsonFile(path)
        let fetchImageListObservable = fetchImageList()
        Observable.zip(checkJsonFileObservable, fetchImageListObservable)
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {
                do {
                    var list = $1.data
                    list.append(model)
                    let listModel = ImageList(data: list)
                    let jsonData = try JSONEncoder().encode(listModel)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    if let url = URL(string:  "file://" + path) {
                        try jsonString?.write(to: url, atomically: false, encoding: .utf8)
                    }
                    result.onNext(true)
                    result.onCompleted()
                } catch {
                    result.onNext(false)
                    result.onCompleted()
                }
            }).disposed(by: disposeBag)
        return result.asObserver().subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func generateImageFilePath(_ path: String, _ name: String) -> String {
        return path + "/\(name)"
    }
    
    func createFile(_ path: String, _ file: Data) -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            guard let url = URL(string: "file://" + path) else {
                observer.onNext(false)
                observer.onCompleted()
                return Disposables.create()
            }
            do {
                try file.write(to: url)
            } catch {
                observer.onError(CustomError.defaultError("something wrong"))
            }
            observer.onNext(true)
            observer.onCompleted()
            return Disposables.create()
        }).subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func checkImageDirectory(_ path: String) -> Observable<Bool> {
        guard fileManager.fileExists(atPath: "file://" + path) else {
            return Observable.create({ (observer) -> Disposable in
                do {
                    if let url = URL(string: "file://" + path) {
                        try self.fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                    }
                    observer.onNext(true)
                    observer.onCompleted()
                } catch {
                    observer.onError(CustomError.defaultError("something wrong"))
                }
                return Disposables.create()
            }).observeOn(SerialDispatchQueueScheduler(qos: .background))
        }
        return Observable.create({ (observer) -> Disposable in
            observer.onNext(true)
            observer.onCompleted()
            return Disposables.create()
        }).subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func checkImageJsonFile(_ path: String) -> Observable<Bool> {
        guard fileManager.fileExists(atPath: path) else {
            return Observable.create({ (observer) -> Disposable in
                do {
                    try "".write(toFile: self.imageJsonFilePath, atomically: false, encoding: .utf8)
                } catch {
                    observer.onError(CustomError.defaultError("something wrong"))
                }
                observer.onNext(true)
                observer.onCompleted()
                return Disposables.create()
            }).subscribeOn(SerialDispatchQueueScheduler(qos: .background))
        }
        return Observable.create({ (observer) -> Disposable in
            observer.onNext(true)
            observer.onCompleted()
            return Disposables.create()
        }).subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
}

extension ImageService: ImageServiceable {
    func fetchImageList() -> Observable<ImageList> {
        guard let url = URL(string: "file://" + self.imageJsonFilePath) else {
            return Observable.just(ImageList(data: [])).subscribeOn(SerialDispatchQueueScheduler(qos: .background))
        }
        return Observable.create({ (observer) -> Disposable in
            do {
                let decoder = JSONDecoder()
                let data = try Data(contentsOf: url)
                let imageList = try decoder.decode(ImageList.self, from: data)
                observer.onNext(imageList)
                observer.onCompleted()
            } catch {
                observer.onNext(ImageList(data: []))
                observer.onCompleted()
            }
            return Disposables.create()
        }).subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func loadImage(_ path: String) -> Observable<Data> {
        return Observable.create({ (observer) -> Disposable in
            do {
                guard let url = URL(string: self.generateImageFilePath( "file://" + self.imageDirectoryPath, path)) else {
                    observer.onError(CustomError.defaultError("something wrong"))
                    return Disposables.create()
                }
                let data = try Data(contentsOf: url)
                observer.onNext(data)
                observer.onCompleted()
            } catch {
                observer.onError(CustomError.defaultError("something wrong"))
            }
            return Disposables.create()
        }).subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func save(_ image: Data, _ name: String, _ time: Double) -> Observable<Bool> {
        let result: ReplaySubject<Bool> = ReplaySubject.create(bufferSize: 1)
        
        let imageFilePath = (name + "\(time)").md5() + ".png"
        let checkObservable = checkImageDirectory(imageDirectoryPath)
        let createFileObservable = createFile(generateImageFilePath(imageDirectoryPath, (name + "\(time)").md5() + ".png"), image)
        let imageModel = ImageModel(name: name, filePath: imageFilePath, createTime: time)
        let addImageJsonObservable = addImageJson(imageJsonFilePath, imageModel)
        
        Observable.zip(checkObservable, createFileObservable, addImageJsonObservable)
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background)).subscribe(onNext: { (arg0) in
                let (result1, result2, result3) = arg0
                result.onNext(result1 && result2 && result3)
                result.onCompleted()
            }).disposed(by: disposeBag)
        return result.asObserver().subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
}

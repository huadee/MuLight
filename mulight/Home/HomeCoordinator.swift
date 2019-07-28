//
//  HomeCoordinator.swift
//  mulight
//
//  Created by jukui liu on 2019/7/28.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import Foundation
import RxSwift

class HomeCoordinator: NSObject, Coordinatable {
    private let disposeBag = DisposeBag()
    private let router: Routable
    
    init(_ router: Routable) {
        self.router = router
        super.init()
    }
    
    func start() {
        let viewModel: HomeViewable = HomeViewModel()
        let viewController: HomeViewPresentable = HomeViewController(viewModel)
        viewController.takePhotoActionObservable.subscribe { (event) in
            //ToDo - push to take photo
        }.disposed(by: disposeBag)
        
        viewController.photoListActionObservable.subscribe { (event) in
            //ToDo - push to photo list
        }.disposed(by: disposeBag)
        router.push(viewController, animated: true, onPop: nil)
    }
}

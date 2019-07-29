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
    var childCoordinators: [Coordinatable] = []
    
    init(_ router: Routable) {
        self.router = router
        super.init()
    }
    
    func start() {
        let viewModel: HomeViewable = HomeViewModel()
        let viewController: HomeViewPresentable = HomeViewController(viewModel)
        viewController.takePhotoActionObservable.subscribe(onNext: { (imagePicker) in
            self.router.present(imagePicker, animated: true)
        }).disposed(by: disposeBag)
        
        viewController.photoListActionObservable.subscribe { (event) in
            let listCoordinator = ListCoordinatror(self.router)
            listCoordinator.start()
            self.addChildCoordinator(listCoordinator)
        }.disposed(by: disposeBag)
        
        viewController.nameInputPopupEventObservable.subscribe(onNext: { (alertController) in
            self.router.present(alertController, animated: true)
        }).disposed(by: disposeBag)

        router.push(viewController, animated: true, onPop: nil)
    }
}

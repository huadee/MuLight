//
//  ListCoordinatror.swift
//  mulight
//
//  Created by jukui liu on 7/29/19.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import Foundation
import RxSwift

class ListCoordinatror: NSObject, Coordinatable {
    
    private let disposeBag = DisposeBag()
    private let router: Routable
    var childCoordinators: [Coordinatable] = []

    init(_ router: Routable) {
        self.router = router
        super.init()
    }
    
    func start() {
        let viewModel: ListViewable = ListViewModel()
        let viewController: ListViewPresentable = ListViewController(viewModel)
        viewController.cellSelectedActionObservable.subscribe(onNext: { (imgePath) in
            let detailCoordinatror = ImageDetailCoordinatror(self.router, imgePath)
            detailCoordinatror.start()
            self.addChildCoordinator(detailCoordinatror)
        }).disposed(by: disposeBag)
        
        router.push(viewController, animated: true, onPop: nil)
    }
}

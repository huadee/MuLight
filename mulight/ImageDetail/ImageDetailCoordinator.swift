//
//  ImageDetailCoordinator.swift
//  mulight
//
//  Created by jukui liu on 7/29/19.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import Foundation
import RxSwift

class ImageDetailCoordinatror: NSObject, Coordinatable {
    
    private let disposeBag = DisposeBag()
    private let router: Routable
    var childCoordinators: [Coordinatable] = []
    
    private let imagePath: String
    
    init(_ router: Routable, _ imagePath: String) {
        self.router = router
        self.imagePath = imagePath
        super.init()
    }
    
    func start() {
        let viewModel: ImageDetailViewable = ImageDetailViewModel(imagePath: imagePath)
        let viewController: ImageDetailViewPresentable = ImageDetailViewController(viewModel)        
        router.push(viewController, animated: true, onPop: nil)
    }
}

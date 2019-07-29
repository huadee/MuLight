//
//  ImageDetailViewController.swift
//  mulight
//
//  Created by jukui liu on 7/29/19.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol ImageDetailViewPresentable: ViewPresentable {
    // ToDo - may changed
}

class ImageDetailViewController: UIViewController, ImageDetailViewPresentable {
    private let disposeBag = DisposeBag()
    private let viewModel: ImageDetailViewable
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    init(_ viewModel: ImageDetailViewable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        viewModel.image().observeOn(MainScheduler.instance).subscribe(onNext: { (data) in
            self.imageView.image = data
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }).disposed(by: disposeBag)
    }
    
    func setupUI() {
        view.accessibilityIdentifier = "imageDetailView"
        view.backgroundColor = UIColor.white
        title = "Detail Image View"
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupBinding() {
        // ToDo - may needed
    }
}

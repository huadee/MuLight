//
//  HomeViewController.swift
//  mulight
//
//  Created by jukui liu on 2019/7/28.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol HomeViewPresentable: ViewPresentable {
    var takePhotoActionObservable: ReplaySubject<Void> { get }
    var photoListActionObservable: ReplaySubject<Void> { get }
}

class HomeViewController: UIViewController, HomeViewPresentable {
    private let disposeBag = DisposeBag()
    private let viewModel: HomeViewable
    
    private lazy var takePhotoButton: UIButton = {
        return generateTapButton("Take a photo")
    }()
    
    private lazy var photoListButton: UIButton = {
        return generateTapButton("View photos")
    }()
    
    init(_ viewModel: HomeViewable) {
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
    }
    
    func setupUI() {
        view.accessibilityIdentifier = "homeView"
        view.backgroundColor = UIColor.white
        view.addSubview(takePhotoButton)
        takePhotoButton.accessibilityIdentifier = "takePhotoButton"
        takePhotoButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalToSuperview().multipliedBy(0.25)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.centerY)
        }
        view.addSubview(photoListButton)
        photoListButton.accessibilityIdentifier = "photoListButton"
        photoListButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalToSuperview().multipliedBy(0.25)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.centerY)
        }
    }
    
    func setupBinding() {
        takePhotoButton.rx.tap.bind(to: takePhotoActionObservable).disposed(by: disposeBag)
        photoListButton.rx.tap.bind(to: photoListActionObservable).disposed(by: disposeBag)
        //ToDo - may need data binding later based on design
    }

    func generateTapButton(_ title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        return button
    }
    
    // MARK: - HomeViewPresentable
    var takePhotoActionObservable: ReplaySubject<Void> = ReplaySubject.create(bufferSize: 1)
    var photoListActionObservable: ReplaySubject<Void> = ReplaySubject.create(bufferSize: 1)
}

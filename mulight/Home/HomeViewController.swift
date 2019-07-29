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
    var takePhotoActionObservable: ReplaySubject<UIViewController> { get }
    var photoListActionObservable: ReplaySubject<Void> { get }
    var nameInputPopupEventObservable: ReplaySubject<UIViewController> { get }
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
        title = "Home View"
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
        let _ = takePhotoButton.rx.tap.subscribe { (_) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.takePhotoActionObservable.onNext(imagePicker)
        }
        photoListButton.rx.tap.bind(to: photoListActionObservable).disposed(by: disposeBag)
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
    
    func popupNameInput() -> Observable<String> {
        let nameSubject = PublishSubject<String>()
        
        let alert = UIAlertController(title: "Save Image", message: "Please enter a image name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "name"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            guard let textField = alert?.textFields?[0], let name = textField.text else {
                nameSubject.onError(CustomError.defaultError("no intput"))
                return
            }
            nameSubject.onNext(name)
            nameSubject.onCompleted()
        }))
        nameInputPopupEventObservable.onNext(alert)
        return nameSubject
    }
    
    // MARK: - HomeViewPresentable
    var takePhotoActionObservable: ReplaySubject<UIViewController> = ReplaySubject.create(bufferSize: 1)
    var photoListActionObservable: ReplaySubject<Void> = ReplaySubject.create(bufferSize: 1)
    var nameInputPopupEventObservable: ReplaySubject<UIViewController> = ReplaySubject.create(bufferSize: 1)
}

// MARK: - UIImagePickerController Delegate
extension HomeViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            self.popupNameInput().subscribe(onNext: { (name) in
                guard let image = info[.originalImage] as? UIImage, let data = image.jpegData(compressionQuality: 0) else { return }
                self.viewModel.saveImage(data, name).subscribe(onNext: { (_) in
                    // Todo - may need some UI notice
                }).disposed(by: self.disposeBag)
            }).disposed(by: self.disposeBag)
        }
    }
}

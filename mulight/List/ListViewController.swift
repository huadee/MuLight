//
//  ListViewController.swift
//  mulight
//
//  Created by jukui liu on 7/29/19.
//  Copyright © 2019 jukui liu. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol ListViewPresentable: ViewPresentable {
    var cellSelectedActionObservable: ReplaySubject<String> { get }
}

class ListViewController: UIViewController, ListViewPresentable {
    private let disposeBag = DisposeBag()
    private let viewModel: ListViewable
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.accessibilityIdentifier = "imagesTableView"
        return tableView
    }()

    init(_ viewModel: ListViewable) {
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
        viewModel.refreshData().subscribe(onNext: { (data) in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    func setupUI() {
        view.accessibilityIdentifier = "listView"
        view.backgroundColor = UIColor.white
        title = "List Image View"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupBinding() {
        // ToDo - may changed
    }
    
    // MARK: - ListViewPresentable
    var cellSelectedActionObservable: ReplaySubject<String> = ReplaySubject.create(bufferSize: 1)
}


extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.image(indexPath.row)
        let identifier = "ImageTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ImageTableViewCell else {
            let cell = ImageTableViewCell(style: .default, reuseIdentifier: identifier)
            cell.update(data)
            tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: identifier)
            return cell
        }
        cell.update(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = viewModel.image(indexPath.row)
        cellSelectedActionObservable.onNext(data.filePath)
    }
}

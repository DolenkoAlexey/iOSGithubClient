//
//  NewsTableViewController.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 07/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsTableViewController: UITableViewController {
    var viewModel: NewsViewModelType!
    
    private let disposeBag = DisposeBag()
    
    var user: Driver<User>!
    var userImage: Driver<UIImage?>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "News"
        setUpBindings()
    }
    
    func setUpBindings() {
        tableView.dataSource = nil
        tableView.delegate = nil
        
        user.flatMapLatest { user in self.viewModel.getEvents(of: user.login!) }
            .map { result -> [Event] in
                switch result {
                case .Success(let repositories):
                    return repositories
                case .Error(let error):
                    UIAlertController.showErrorAlert(error.description, context: self)
                    return []
                }
            }
            .drive(tableView.rx.items(
                cellIdentifier: Constants.CellIdentifiers.news,
                cellType: NewsTableViewCell.self)
            ) { (_, event, cell) in
                cell.userImage = self.userImage
                cell.user = self.user
                cell.event = event
            }.disposed(by: disposeBag)
    }

}

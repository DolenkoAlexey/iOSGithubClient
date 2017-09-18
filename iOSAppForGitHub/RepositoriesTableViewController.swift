//
//  RepositoriesTableViewController.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 07/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RepositoriesTableViewController: UITableViewController {
    var viewModel: RepositoriesViewModelType!
    var repositories: Driver<RequestResult<[Repository]>>!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
    }
    
    func setUpBindings() {
        tableView.dataSource = nil
        tableView.delegate = nil
        
        repositories.map { result -> [Repository] in
                switch result {
                case .Success(let repositories):
                    return repositories
                case .Error(let error):
                    UIAlertController.showErrorAlert(error.description, context: self)
                    return []
                }
            }
            .drive(tableView.rx.items(
                cellIdentifier: Constants.CellIdentifiers.repository,
                cellType: RepositoryTableViewCell.self)
            ) { (_, element, cell) in
                cell.repository = element
            }.disposed(by: disposeBag)
    }
}

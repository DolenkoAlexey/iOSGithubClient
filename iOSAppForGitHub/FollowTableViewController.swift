//
//  FollowTableViewController.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 19/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FollowTableViewController: UITableViewController {
    var viewModel: FollowViewModelType!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
        setUIBindings()
    }
    
    private func setUIBindings() {
        viewModel.getUsers()
            .map {[weak self] result -> [User] in
                switch result {
                case .Success(let users):
                    return users
                case .Error(let error):
                    UIAlertController.showErrorAlert(error.description, context: self)
                    return []
                }
            }
            .drive(tableView.rx.items(
                cellIdentifier: Constants.CellIdentifiers.follow,
                cellType: FollowTableViewCell.self)
            ) {[weak self] (_, user, cell) in
                cell.user = user
                cell.avatar = self?.viewModel.getUserAvatar(by: user.avatarUrl!)
            }.disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.showUser,
            let userViewController = segue.destination as? UserViewController,
            let userName = (sender as? FollowTableViewCell)?.user?.login {
                userViewController.userName = Driver.just(userName)
                userViewController.viewModel = UserViewModel()
        }
    }
}

//
//  IssuesTableViewController.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 07/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SubscriptionsTableViewController: UITableViewController {
    var viewModel: SubscriptionViewModelType!
    var currentUserName: String!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
        setUIBindings()
    }
    
    private func setUIBindings() {
        viewModel.getSubscriptions(of: currentUserName)
            .map { result -> [Subscription] in
                switch result {
                case .Success(let subscriptions):
                    return subscriptions
                case .Error(let error):
                    UIAlertController.showErrorAlert(error.description, context: self)
                    return []
                }
            }
            .drive(tableView.rx.items(
                cellIdentifier: Constants.CellIdentifiers.subscriptions,
                cellType: SubscriptionTableViewCell.self)
            ) { (_, subscription, cell) in
                cell.subscription = subscription
                
                if let avatarUrl = subscription.owner?.avatarUrl {
                    cell.userImage = self.viewModel.getUserAvatar(by: avatarUrl).map {
                        switch $0 {
                        case .Success(let image):
                            return image
                        case .Error(let error):
                            print(error)
                            return UIImage(named: Constants.ImageNames.userNotFound)
                        }
                    }
                }
            }.disposed(by: disposeBag)
    }
}

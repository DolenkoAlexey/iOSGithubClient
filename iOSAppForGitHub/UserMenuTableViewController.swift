//
//  UserMenuTableViewController.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 07/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import Moya
import MoyaSugar
import RxSwift
import RxCocoa

class UserMenuTableViewController: UITableViewController {
    var user: Driver<User>! {
        didSet {
            user.drive(onNext: { self.currentUserName = $0.login }).addDisposableTo(disposeBag)
        }
    }
    
    var userImage: Driver<Image?>!
    
    private let disposeBag = DisposeBag()
    private var currentUserName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.news,
            let newsTableViewController = segue.destination as? NewsTableViewController {
            
                newsTableViewController.viewModel = NewsViewModel()
                newsTableViewController.user = user
                newsTableViewController.userImage = userImage
        }
        
        if segue.identifier == Constants.SegueIdentifiers.repositories,
            let repositoriesTableViewController = segue.destination as? RepositoriesTableViewController,
            let username = currentUserName {
            
                repositoriesTableViewController.viewModel = RepositoriesViewModel()
                repositoriesTableViewController.repositories = repositoriesTableViewController
                    .viewModel
                    .getRepositories(destination: .userRepositories(username))
        }
        
        if segue.identifier == Constants.SegueIdentifiers.subscriptions,
            let subscriptionsTableViewController = segue.destination as? SubscriptionsTableViewController,
            let username = currentUserName {
                subscriptionsTableViewController.viewModel = SubscriptionViewModel(userViewModel: UserViewModel())
                subscriptionsTableViewController.currentUserName = username
        }
    }
}

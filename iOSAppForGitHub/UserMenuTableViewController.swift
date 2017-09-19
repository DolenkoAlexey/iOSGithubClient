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
    var userName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier,
            identifier == Constants.SegueIdentifiers.news,
            let newsTableViewController = segue.destination as? NewsTableViewController {
                newsTableViewController.viewModel = NewsTableViewModel()
        }
        
        if let identifier = segue.identifier,
            identifier == Constants.SegueIdentifiers.repositories,
            let repositoriesTableViewController = segue.destination as? RepositoriesTableViewController {
            
            repositoriesTableViewController.viewModel = RepositoriesViewModel()
            repositoriesTableViewController.repositories = repositoriesTableViewController
                .viewModel
                .getRepositories(destination: .userRepositories(userName))
        }
    }

}

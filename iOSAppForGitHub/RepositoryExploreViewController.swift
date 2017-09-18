//
//  RepositoryExploreViewController.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 08/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import MoyaSugar

class RepositoryExploreViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private var searchText: Driver<String> {
        return searchBar.rx.text
            .orEmpty
            .asDriver()
            .throttle(0.3)
            .distinctUntilChanged()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier,
            identifier == Constants.SegueIdentifiers.repositoriesExplore,
            let repositoriesTableViewController = segue.destination as? RepositoriesTableViewController {
            
            
            let repositories = searchText.flatMapLatest { text -> SharedSequence<DriverSharingStrategy, RequestResult<[Repository]>> in
                if text.isEmpty {
                    return .just(.Success([]))
                }
                return repositoriesTableViewController.viewModel.getRepositories(destination: .repositories(text))
            }
            
            repositoriesTableViewController.viewModel = RepositoriesViewModel()
            repositoriesTableViewController.repositories = repositories
        }
    }

}

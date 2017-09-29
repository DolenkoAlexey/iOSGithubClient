//
//  RepositoryMenuTableViewController.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 27/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RepositoryMenuTableViewController: UITableViewController {
    
    @IBOutlet weak var isPrivateLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var issuesCountLabel: UILabel!
    @IBOutlet weak var branchesCountLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    var repository: Repository! {
        didSet {
            self.isPrivateLabel.text = (repository.isPrivate ?? false) ? "Private" : "Public"
            self.languageLabel.text = repository.language ?? "Unknown"
            self.issuesCountLabel.text = "\(repository.issuesCount ?? -1)"
            self.updatedDateLabel.text = repository.updateDate ?? "Unknown"
            self.sizeLabel.text = "\(repository.size ?? -1)KB"
        }
    }
    
    var viewModel: RepositoryViewModelType! {
        didSet {
            viewModel.repository.drive(onNext: { [weak self] repository in
                self?.repository = repository
            }).addDisposableTo(disposeBag)
            
            viewModel.branchesCount.drive(onNext: { [weak self] branchesCount in
                self?.branchesCountLabel.text = "\(branchesCount)"
            }).addDisposableTo(disposeBag)
        }
    }
}

// MARK: - Navigation
extension RepositoryMenuTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.showUser,
            let userViewController = segue.destination as? UserViewController,
            let username = repository.owner?.login {
                userViewController.userName = Driver.just(username)
                userViewController.viewModel = UserViewModel()
        }
        
        if segue.identifier == Constants.SegueIdentifiers.dirSource,
            let sourceTableViewController = segue.destination as? DirSourceTableViewController {
       
                sourceTableViewController.viewModel = DirSourceViewModel(repository: repository)
        }
    }
}

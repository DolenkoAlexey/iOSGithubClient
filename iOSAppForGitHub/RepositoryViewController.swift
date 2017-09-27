//
//  RepositoryViewController.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 26/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import RxOptional
import RxCocoa
import RxSwift

class RepositoryViewController: UIViewController {
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var watchersCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    
    var viewModel: RepositoryViewModelType!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        viewModel.repository.drive(onNext: {[weak self] repository in
            self?.starsCountLabel.text = "\(repository.starsCount ?? 0)"
            self?.watchersCountLabel.text = "\(repository.watchersCount ?? 0)"
            self?.forksCountLabel.text = "\(repository.forksCount ?? 0)"
            self?.navigationItem.title = repository.name ?? ""
        }).addDisposableTo(disposeBag)
        
        viewModel.error.drive(onNext: {[weak self] error in
            let errorDesc = error.code == .notFound ? "Repository not found" : error.description
            UIAlertController.showErrorAlert(errorDesc, context: self)
        }).addDisposableTo(disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.repositoryMenuEmbed,
            let repositoryMenuTableViewController = segue.destination as? RepositoryMenuTableViewController {
            repositoryMenuTableViewController.viewModel = viewModel
        }
    }
}

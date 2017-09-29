//
//  SourceTableViewController.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 28/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import RxSwift

class DirSourceTableViewController: UITableViewController {
    var viewModel: DirSourceViewModelType!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        tableView.dataSource = nil
        tableView.delegate = nil
        
        viewModel.getContent()
            .drive(tableView.rx.items(
                cellIdentifier: Constants.CellIdentifiers.source,
                cellType: DirSourceTableViewCell.self))
            { (_, content, sourceTableViewCell) in
                sourceTableViewCell.content = content
            }.addDisposableTo(disposeBag)
        
        tableView.rx.itemSelected.map{ $0 }.subscribe(onNext: {[weak self] indexPath in
            let cell = self?.tableView.cellForRow(at: indexPath) as? DirSourceTableViewCell
            if cell?.content.type != .dir {
                self?.performSegue(withIdentifier: Constants.SegueIdentifiers.fileSource, sender: cell)
            }
        }).addDisposableTo(disposeBag)
    }
}

//MARK: - Navigation
extension DirSourceTableViewController {
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Constants.SegueIdentifiers.dirSource,
            (sender as? DirSourceTableViewCell)?.content.type != .dir {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.dirSource,
            let sourceTableViewController = segue.destination as? DirSourceTableViewController,
            let selectedSourceContent = (sender as? DirSourceTableViewCell)?.content {
            
            sourceTableViewController.viewModel = viewModel.getContentViewModel(of: selectedSourceContent.path)
        }
        
        if segue.identifier == Constants.SegueIdentifiers.fileSource,
            let sourceTableViewController = segue.destination as? FileSourceViewController,
            let selectedSourceContent = (sender as? DirSourceTableViewCell)?.content {
            sourceTableViewController.viewModel = FileSourceViewModel(repository: viewModel.repository, path: selectedSourceContent.path)
        }
    }
}

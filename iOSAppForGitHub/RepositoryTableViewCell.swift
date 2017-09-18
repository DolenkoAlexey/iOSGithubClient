//
//  RepositoryTableViewCell.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 08/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    
    var repository: Repository! {
        didSet {
            repositoryNameLabel.text = repository.name ?? ""
            ownerLabel.text = repository.owner?.login ?? ""
            starsCountLabel.text = "\(repository.starsCount ?? 0)"
            forksCountLabel.text = "\(repository.forksCount ?? 0)"
        }
    }
    
}

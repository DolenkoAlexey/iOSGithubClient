//
//  RepositoryTableViewCell.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 08/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    @IBOutlet weak var repositoryName: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    
    var repository: Repository! {
        didSet {
            repositoryName.text = repository.name ?? ""
            starsCountLabel.text = "\(repository.starsCount ?? 0)"
            watchersLabel.text = "\(repository.watchersCount ?? 0)"
        }
    }
    
}

//
//  SourceTableViewCell.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 28/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit

class DirSourceTableViewCell: UITableViewCell {

    @IBOutlet weak var contentNameLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    
    var content: DirContent! {
        didSet {
            contentNameLabel.text = content.name
            
            switch content.type {
            case .file:
                contentImageView.image = #imageLiteral(resourceName: "file")
            case .dir:
                contentImageView.image = #imageLiteral(resourceName: "folder-2")
            case .unknown:
                contentImageView.image = #imageLiteral(resourceName: "question-mark-button")
            }
        }
    }
}

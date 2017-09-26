//
//  NewsTableViewCell.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 19/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    var user: Driver<User>! {
        didSet {
            user.drive(onNext: {[weak self] user in self?.userNameLabel.text = user.login }).addDisposableTo(disposeBag)
        }
    }
    
    var userImage: Driver<UIImage?>! {
        didSet {
            userImage.drive(onNext: {[weak self] image in self?.userImageView.image = image }).addDisposableTo(disposeBag)
        }
    }
    
    var event: Event! {
        didSet {
            repositoryNameLabel.text = event.repositoryName
            eventTypeLabel.text = event.type
            dateLabel.text = event.eventDate
            timeLabel.text = event.eventTime
        }
    }
}

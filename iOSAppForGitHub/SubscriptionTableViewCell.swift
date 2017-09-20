//
//  SubscriptionTableViewCell.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 20/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SubscriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var subscriptionNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    var subscription: Subscription! {
        didSet {
            lastUpdateLabel.text = subscription.lastUpdate
            usernameLabel.text = subscription.owner?.login
            subscriptionNameLabel.text = subscription.name
            starsCountLabel.text = "\(subscription.starsCount ?? 0)"
            descriptionLabel.text = subscription.description
        }
    }
    
    var userImage: Driver<UIImage?>! {
        didSet {
            userImage.drive(onNext: { image in self.userAvatarImageView.image = image }).addDisposableTo(disposeBag)
        }
    }
}

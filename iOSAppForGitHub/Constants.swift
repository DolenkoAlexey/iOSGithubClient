//
//  Constants.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 10/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation

struct Constants {
    struct SegueIdentifiers {
        static let repositoriesExplore = "repositoriesExploreSegue"
        static let news = "newsSegue"
        static let repositories = "repositoriesSegue"
        static let subscriptions = "subscriptionsSegue"
        static let userMenuEmbed = "userMenuEmbedSegue"
        static let userEmbed = "userEmbedSegue"
        static let following = "followingSegue"
        static let followers = "followersSegue"
        static let showUser = "showUserSegue"
    }
    
    struct CellIdentifiers {
        static let repository = "RepositoryCell"
        static let follow = "FollowCell"
        static let news = "NewsCell"
        static let subscriptions = "SubscriptionCell"
    }
    
    struct ImageNames {
        static let userNotFound = "userNotFound"
    }
    
    struct API {
        // Url's
        static let baseGitHubUrl = "https://api.github.com"
        
        // Headers
        static let acceptHeader = "application/vnd.github.v3+json"
    }
}

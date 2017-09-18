//
//  UserModel.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 03/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation
import ObjectMapper

public struct User: ImmutableMappable {
    let login: String?
    let avatarUrl: String?
    let followersUrl: String?
    let followersCount: String?
    let followingCount: String?
    
    public init(map: Map) throws {
        login = try? map.value("login")
        avatarUrl = try? map.value("avatar_url")
        followersUrl = try? map.value("followers_url")
        
        if let followersCount: Int = try? map.value("followers") {
            self.followersCount = "\(followersCount)"
        } else { self.followersCount = nil }
        
        if let followingCount: Int = try? map.value("following") {
            self.followingCount = "\(followingCount)"
        } else { self.followingCount = nil}
    }
}

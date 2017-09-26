//
//  Subscription.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 20/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Subscription: ImmutableMappable {
    let name: String?
    let description: String?
    let starsCount: Int?
    let lastUpdate: String?
    let owner: User?
    
    public init(map: Map) throws {
        name = try? map.value("name")
        description = try? map.value("description")
        starsCount = try? map.value("forks_count")
        owner = try? map.value("owner")
        
        if let date = (try? map.value("updated_at")) as String?,
            let updateDate = date.date(),
            let updateTime = date.time() {
            lastUpdate = updateDate + " at " + updateTime
        } else {
            lastUpdate = nil
        }
    }

}

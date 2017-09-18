//
//  Repository.swift
//  Pods
//
//  Created by Alex Dolenko on 08/09/2017.
//
//

import Foundation
import ObjectMapper

public struct Repository: ImmutableMappable {
    let name: String?
    let starsCount: Int?
    let watchersCount: Int?
    let owner: User?
    
    public init(map: Map) throws {
        name = try? map.value("name")
        starsCount = try? map.value("stargazers_count")
        watchersCount = try? map.value("watchers_count")
        owner = try? map.value("owner")
    }
}

public struct Repositories: ImmutableMappable {
    let repositories: [Repository]?
    
    public init(map: Map) throws {
        repositories = try? map.value("items")
    }
}

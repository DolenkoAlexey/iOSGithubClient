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
    let forksCount: Int?
    let issuesCount: Int?
    let watchersCount: Int?
    let owner: User?
    let isPrivate: Bool?
    let language: String?
    let updateDate: String?
    let size: Int?
    
    public init(map: Map) throws {
        name = try? map.value("name")
        starsCount = try? map.value("stargazers_count")
        forksCount = try? map.value("forks_count")
        issuesCount = try? map.value("open_issues")
        watchersCount = try? map.value("watchers_count")
        isPrivate = try? map.value("private")
        language = try? map.value("language")
        owner = try? map.value("owner")
        size = try? map.value("size")
        if let updateDate = try? map.value("updated_at") as String {
            self.updateDate = updateDate.date() ?? ""
        } else {
            self.updateDate = nil
        }
    }
}

public struct Repositories: ImmutableMappable {
    let repositories: [Repository]?
    
    public init(map: Map) throws {
        repositories = try? map.value("items")
    }
}

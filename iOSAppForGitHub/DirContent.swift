//
//  Content.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 28/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation
import ObjectMapper

public struct DirContent: ImmutableMappable {
    let name: String
    let path: String
    let type: ContentType
    
    public init(map: Map) throws {
        name = try map.value("name")
        path = try map.value("path")
        switch try map.value("type") as String {
        case "dir":
            type = .dir
        case "file":
            type = .file
        default:
            type = .unknown
        }
    }
}

public enum ContentType {
    case dir
    case file
    case unknown
}

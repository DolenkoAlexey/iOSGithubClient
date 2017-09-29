//
//  FileContent.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 29/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import ObjectMapper

public struct FileContent: ImmutableMappable {
    let content: String
    
    public init(map: Map) throws {
        content = try map.value("content")
    }
}

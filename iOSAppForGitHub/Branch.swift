//
//  Branch.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 27/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//
import ObjectMapper

public struct Branch: ImmutableMappable {
    let name: String?
    
    public init(map: Map) throws {
        name = try? map.value("name")
    }
    
}


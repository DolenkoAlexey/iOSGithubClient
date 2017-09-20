//
//  Event.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 19/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Event: ImmutableMappable {
    let type: String?
    let repositoryName: String?
    let eventDate: String?
    let eventTime: String?
    
    public init(map: Map) throws {
        repositoryName = try? map.value("repo.name")
        
        if let type = (try? map.value("type")) as String? {
            self.type = type.CamelCaseToWords()
        } else { self.type = nil }
        
        if let date = (try? map.value("created_at")) as String? {
            eventDate = date.date()
            eventTime = date.time()
        } else {
            eventTime = nil
            eventDate = nil
        }
    }
}

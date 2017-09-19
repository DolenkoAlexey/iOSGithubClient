//
//  String+DateFormat.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 20/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation

extension String {
    func getDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return formatter.date(from: self)
    }
    
    func date() -> String? {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MM.dd.yyyy"
        let date = self.getDate()
        return date != nil ? formatter.string(from: date!) : nil
    }
    
    func time() -> String? {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "HH:mm:ss"
        let date = self.getDate()
        return date != nil ? formatter.string(from: date!) : nil
    }
}

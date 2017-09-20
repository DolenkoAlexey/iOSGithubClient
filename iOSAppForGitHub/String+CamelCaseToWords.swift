//
//  String+CamelCaseToWords.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 20/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import Foundation

extension String {
    func CamelCaseToWords() -> String {
        
        return unicodeScalars.reduce("") {
            
            if CharacterSet.uppercaseLetters.contains($1) == true && !$0.isEmpty {
                
                return ($0 + " " + String($1))
            }
            else {
                
                return $0 + String($1)
            }
        }
    }

}

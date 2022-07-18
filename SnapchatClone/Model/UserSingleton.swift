//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Mustafa on 17.07.2022.
//

import Foundation

class UserSingleton {
     
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    
    private init() {
        
    }
}

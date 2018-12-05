//
//  User.swift
//  WinkKitTestApp
//
//  Created by Rico Crescenzio on 27/08/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

class User: Swift.Decodable {
    
    init(id: Int, firstName: String, lastName: String, profileImage: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.profileImage = profileImage
        
    }
    
    let id: Int
    let firstName: String
    let lastName: String
    let profileImage: String?
}

extension User: CustomStringConvertible {
    var description: String {
        return """
        User: {
        id: \(id)
        name: \(firstName)
        surname: \(lastName)
        profile image: \(profileImage ?? "no image")
        }
"""
    }
}

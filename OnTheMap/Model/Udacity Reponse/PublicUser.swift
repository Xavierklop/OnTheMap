//
//  PublicUser.swift
//  OnTheMap
//
//  Created by Hao Wu on 10.06.19.
//  Copyright © 2019 Hao Wu. All rights reserved.
//

import Foundation

struct PublicUser: Codable {
    let key: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case key
    }
}

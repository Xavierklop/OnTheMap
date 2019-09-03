//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Hao Wu on 03.06.19.
//  Copyright © 2019 Hao Wu. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

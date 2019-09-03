//
//  StudentLocationRequest.swift
//  OnTheMap
//
//  Created by Hao Wu on 10.06.19.
//  Copyright © 2019 Hao Wu. All rights reserved.
//

import Foundation

struct StudentLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}

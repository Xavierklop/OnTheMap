//
//  Student.swift
//  OnTheMap
//
//  Created by Hao Wu on 06.06.19.
//  Copyright © 2019 Hao Wu. All rights reserved.
//

import Foundation

struct Student: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}

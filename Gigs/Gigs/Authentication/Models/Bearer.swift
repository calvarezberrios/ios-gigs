//
//  Beaarer.swift
//  Gigs
//
//  Created by Carlos E. Alvarez-Berrios on 4/15/24.
//  Copyright © 2024 Emani Computers and Support, LLC. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let userId: Int
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case token
    }
}

//
//  Gig.swift
//  Gigs
//
//  Created by Carlos E. Alvarez-Berrios on 4/17/24.
//  Copyright © 2024 Emani Computers and Support, LLC. All rights reserved.
//

import Foundation

struct Gig: Codable {
    let title: String
    let description: String
    let dueDate: Date?
}

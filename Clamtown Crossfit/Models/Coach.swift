//
//  Coach.swift
//  Clamtown Crossfit
//
//  Created by scott harris on 4/30/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation

struct Coach: Codable {
    let name: String
    let profileImgURL: URL
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileImgURL = "profile_img_url"
    }
    
}

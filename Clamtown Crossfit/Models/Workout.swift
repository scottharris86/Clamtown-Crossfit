//
//  Workout.swift
//  Clamtown Crossfit
//
//  Created by scott harris on 4/30/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation

struct Workout: Codable {
    let date: String
    let thumbnailURL: URL
    let videoURL: URL
    let title: String
    let movements: String
    
    let coach: Coach
    
    enum CodingKeys: String, CodingKey {
        case date
        case movements
        case thumbnailURL = "thumbnail_url"
        case videoURL = "video_url"
        case title
        case coach
    }
    
}

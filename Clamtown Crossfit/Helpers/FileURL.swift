//
//  FileURL.swift
//  Clamtown Crossfit
//
//  Created by scott harris on 4/28/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation

class FileURL {
//    var mainBundle: URL? {
//        let mainBundle = Bundle.main
//        return mainBundle
//    }
    
    var resourcesDirectory: URL? {
        print(Bundle.main.url(forResource: "ABS", withExtension: "m4v"))
        let resources = Bundle.main.url(forResource: "ABS", withExtension: "m4v")
        return resources
 
    }
    
}

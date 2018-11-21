//
//  CacheManager.swift
//  GifCatalogue
//
//  Created by e.vanags on 21/11/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import Foundation
import UIKit

struct CacheManager {

    static private(set) var shared = CacheManager()

    let cache = NSCache<NSString, UIImage>()

    private init() {
        cache.countLimit = 100
    }
}

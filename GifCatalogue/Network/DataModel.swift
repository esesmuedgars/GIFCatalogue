//
//  DataModel.swift
//  GifCatalogue
//
//  Created by e.vanags on 17/11/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import Foundation

struct GIPHYResponse: Decodable {
    private var data: [GIPHYData]

    var urls: [String] {
        return data.map { $0.images.preview.url }
    }
}

private struct GIPHYData: Decodable {
    var images: GIPHYImage
}

private struct GIPHYImage: Decodable {
    var preview: GIPHYPreview

    enum CodingKeys: String, CodingKey {
        case preview = "fixed_width"
    }
}

private struct GIPHYPreview: Decodable {
    var url: String
}

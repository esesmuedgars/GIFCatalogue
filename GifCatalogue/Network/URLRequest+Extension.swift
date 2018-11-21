//
//  URLRequest+Extension.swift
//  GifCatalogue
//
//  Created by e.vanags on 16/11/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import Foundation

extension URLRequest {
    private static var Base: String {
        return "https://api.giphy.com/v1/gifs/search"
    }

    init(with parameters: [URLQueryItem]) {
        let url = URL(string: URLRequest.Base)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = parameters

        self.init(url: components.url!)
    }
}

enum Parameter: String {
    case query = "q"
    case key = "api_key"
    case limit = "limit"
    case offset = "offset"
}

extension URLQueryItem {
    init(with parameter: Parameter, value: String) {
        self.init(name: parameter.rawValue, value: value)
    }

    init(with parameter: Parameter, value: Int) {
        self.init(name: parameter.rawValue, value: String(value))
    }
}

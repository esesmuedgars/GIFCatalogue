//
//  APIService.swift
//  GifCatalogue
//
//  Created by Edgars Vanags on 22/01/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import Foundation

protocol APIServiceProtocol {
    func fetchGIFs(query: String, offset: Int, success: @escaping (GIPHYResponse) -> ())
}

struct APIService: APIServiceProtocol {

    private static var API_KEY: String {
        return "XVROvtKUUF7ctQK9rZQgX54N9RiRY2V8"
    }

    func fetchGIFs(query: String, offset: Int, success: @escaping (GIPHYResponse) -> ()) {
        let request = URLRequest(with: [URLQueryItem(with: .query, value: query),
                                        URLQueryItem(with: .limit, value: 20),
                                        URLQueryItem(with: .offset, value: offset),
                                        URLQueryItem(with: .key, value: APIService.API_KEY)])

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                guard let data = data, error == nil, let response = response as? HTTPURLResponse else {
                    throw "Fetch GIFs API call returned no data."
                }

                guard 200 ... 299 ~= response.statusCode else {
                    throw "Expected response status code in range between 200 - 299, but received \(response.statusCode)."
                }

                success(try JSONDecoder().decode(GIPHYResponse.self, from: data))
            } catch {
                print(error.localizedDescription.errorDescription as Any)
            }
        }.resume()
	}
}

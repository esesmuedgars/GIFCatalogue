//
//  APIService.swift
//  GifCatalogue
//
//  Created by Edgars Vanags on 22/01/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol APIServiceProtocol {
    func fetchGIFs(query: String, offset: Int) -> Observable<GIPHYResponse>
}

struct APIService: APIServiceProtocol {

    private static var Key: String {
        return "XVROvtKUUF7ctQK9rZQgX54N9RiRY2V8"
    }

    private static var ItemLimit: Int {
        return 10
    }

    func fetchGIFs(query: String, offset: Int) -> Observable<GIPHYResponse> {
        let request = URLRequest(with: [URLQueryItem(with: .query, value: query),
                                        URLQueryItem(with: .offset, value: offset),
                                        URLQueryItem(with: .limit, value: APIService.ItemLimit),
                                        URLQueryItem(with: .key, value: APIService.Key)])

        return Observable<GIPHYResponse>.create { observer in
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    guard let data = data, error == nil, let response = response as? HTTPURLResponse else {
                        throw "Fetch GIFs API call returned no data."
                    }

                    guard 200 ... 300 ~= response.statusCode else {
                        throw "Expected response success status code, but received \(response.statusCode)."
                    }

                    observer.onNext(try JSONDecoder().decode(GIPHYResponse.self, from: data))
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}

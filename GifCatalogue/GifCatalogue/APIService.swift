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
import GiphyCoreSDK

protocol APIServiceProtocol {
    func fetchGIFs(query: String, offset: Int) -> Observable<[GPHMedia]>
}

struct APIService: APIServiceProtocol {

    init() {
        GiphyCore.configure(apiKey: "XVROvtKUUF7ctQK9rZQgX54N9RiRY2V8")
    }

    func fetchGIFs(query: String, offset: Int) -> Observable<[GPHMedia]> {
        return Observable<[GPHMedia]>.create { observer in
            GiphyCore.shared.search(query, offset: offset, limit: 10) { (response, error) in
                do {
                    guard let data = response?.data, error == nil else {
                        throw "Fetch GIFs API call returned no data."
                    }

                    observer.onNext(data)
                } catch {
                    observer.onError(error)
                }

                observer.onCompleted()
            }

            return Disposables.create()
        }
    }
}

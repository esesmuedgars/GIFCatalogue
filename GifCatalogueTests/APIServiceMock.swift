//
//  APIServiceMock.swift
//  GifCatalogueTests
//
//  Created by e.vanags on 21/11/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import Foundation
import RxSwift
@testable import GifCatalogue

struct APIServiceMock: APIServiceProtocol {

    func fetchGIFs(query: String, offset: Int) -> Observable<GIPHYResponse> {
        return Observable<GIPHYResponse>.create { observer in
            do {
                observer.onNext(try JSONDecoder().decode(GIPHYResponse.self, from: try data()))
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }

            return Disposables.create()
        }
    }
}

private var dictionary: [String: Any] {
    return ["data": [
            ["images": [
                    "fixed_width": [
                        "url": "1.gif"
                    ]
                ]
            ],
            ["images": [
                    "fixed_width": [
                        "url": "2.gif"
                    ]
                ]
            ],
            ["images": [
                    "fixed_width": [
                        "url": "3.gif"
                    ]
                ]
            ]
        ]
    ]
}

private func data() throws -> Data {
    return try JSONSerialization.data(withJSONObject: dictionary, options: [])
}

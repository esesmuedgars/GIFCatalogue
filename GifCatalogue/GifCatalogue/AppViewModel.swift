//
//  AppViewModel.swift
//  GifCatalogue
//
//  Created by e.vanags on 16/11/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import Foundation
import RxSwift

final class AppViewModel {

    private let apiService: APIServiceProtocol
    private(set) lazy var disposeBag = DisposeBag()
    private(set) lazy var didLoadItems = Bool()

    private let images = Variable(Array<String>())
    var observable: Observable<[String]> {
        return images.asObservable()
    }

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func fetch(query: String) -> Observable<[String]> {
        didLoadItems = false

        apiService.fetchGIFs(query: query, offset: images.value.count)
            .map { [weak self] response in
                self?.images.value.append(contentsOf: response.urls)
            }.subscribe { [weak self] event in
                self?.didLoadItems = event.isCompleted
            }.disposed(by: disposeBag)

        return images.asObservable()
    }

    func clearItems() -> Observable<[String]> {
        images.value.removeAll()
        cache.removeAllObjects()

        return images.asObservable()
    }

    func numberOfItems() -> Int {
        return images.value.count
    }
}

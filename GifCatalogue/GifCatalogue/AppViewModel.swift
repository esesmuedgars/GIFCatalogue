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

    private let items = Variable(Array<String>())
    var observableItems: Observable<[String]> {
        return items.asObservable()
    }

    lazy var shouldClearItems = Bool()

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func fetchItems(query: String) -> Observable<[String]> {
        didLoadItems = false

        apiService.fetchGIFs(query: query, offset: items.value.count)
            .map { [weak self] response in
                self?.items.value.append(contentsOf: response.urls)
            }.subscribe { [weak self] event in
                self?.didLoadItems = event.isCompleted
                self?.shouldClearItems = true
            }.disposed(by: disposeBag)

        return observableItems
    }

    func clearItems() {
        items.value.removeAll()
        CacheManager.shared.cache.removeAllObjects()
    }

    func numberOfItems() -> Int {
        return items.value.count
    }

    func d() -> Bool {
        return items.value.hasContent
    }
}

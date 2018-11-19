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

    private var apiService: APIServiceProtocol
    lazy var disposeBag = DisposeBag()

    private let images: Variable<[String]> = Variable([])
    var itemsLoaded = false

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func fetch(query: String) -> Observable<[String]> {
        itemsLoaded = false

        apiService.fetchGIFs(query: query, offset: images.value.count)
            .map { [weak self] response in
                for url in response.urls {
                    self?.images.value.append(url)
                }
            }.subscribe { [weak self] event in
                self?.itemsLoaded = event.isCompleted
            }.disposed(by: disposeBag)

        return images.asObservable()
    }

    func item(_ indexPath: IndexPath) -> String {
        return images.value[indexPath.row]
    }

    func clearItems() -> Observable<[String]> {
        images.value.removeAll()

        return images.asObservable()
    }

    func numberOfItems() -> Int {
        return images.value.count
    }
}

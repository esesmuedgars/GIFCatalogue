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

    private let images: Variable<[Data]> = Variable([])
    var itemsLoaded = false

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func fetch(query: String) -> Observable<[Data]> {
        itemsLoaded = false

        apiService.fetchGIFs(query: query, offset: images.value.count)
            .map { [weak self] response in
                for media in response {
                    if let data = try? Data(url: media.url) {
                        self?.images.value.append(data)
                    }
                }
            }.subscribe { [weak self] event in
                self?.itemsLoaded = event.isCompleted
            }.disposed(by: disposeBag)

        return images.asObservable()
    }

    func item(_ indexPath: IndexPath) -> Data {
        return images.value[indexPath.row]
    }

    func clearItems() -> Observable<[Data]> {
        images.value.removeAll()

        return images.asObservable()
    }

    func numberOfItems() -> Int {
        return images.value.count
    }
}

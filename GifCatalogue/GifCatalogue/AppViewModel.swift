//
//  AppViewModel.swift
//  GifCatalogue
//
//  Created by e.vanags on 16/11/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import Foundation
import UIKit

class AppViewModel {

    var insertData: ((IndexPath) -> Void)?
    var reloadData: (() -> Void)?

    private let apiService: APIServiceProtocol
    private var images = [UIImage?]()
    var itemsLoaded = false

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func fetch(query: String) {
        itemsLoaded = false

        apiService.fetchGIFs(query: query, offset: images.count) { [weak self] response in
            for url in response.urls {
                self?.insert(url)
            }

            self?.itemsLoaded = true
        }
    }

    private func insert(_ string: String) {
        images.append(UIImage.gifImage(url: string))
        insertData?(IndexPath(row: images.count - 1, section: 0))
    }

    func item(_ indexPath: IndexPath) -> UIImage? {
        return images[indexPath.row]
    }

    func clearItems() {
        images.removeAll()
        reloadData?()
    }

    func numberOfItems() -> Int {
        return images.count
    }
}

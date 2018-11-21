//
//  AppViewModelTests.swift
//  GifCatalogueTests
//
//  Created by e.vanags on 21/11/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import XCTest
import RxSwift
@testable import GifCatalogue

final class AppViewModelTests: XCTestCase {

    private lazy var viewModel = AppViewModel(apiService: APIServiceMock())

    func testInitialState() {
        XCTAssertEqual(viewModel.numberOfItems(), 0, "Incorrect initial number of items.")
    }

    func testFetchItems() {
        var hasContent = true

        viewModel.fetchItems(query: String())
            .subscribe { event in
                guard let items = event.element else {
                    XCTFail()
                    return
                }

                XCTAssertEqual(items.count, hasContent ? 3 : 0, "Fetched incorrect number of items.")
            }.disposed(by: viewModel.disposeBag)

        hasContent = false
        viewModel.clearItems()
    }
}

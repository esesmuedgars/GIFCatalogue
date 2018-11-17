//
//  AppViewController.swift
//  GifCatalogue
//
//  Created by Edgars Vanags on 18/01/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import UIKit

class AppViewController: UIViewController {

	@IBOutlet private weak var searchBar: UISearchBar!
	@IBOutlet private weak var collectionView: UICollectionView!

    private lazy var viewModel = AppViewModel()
    private lazy var gestureRecognizer = UITapGestureRecognizer(target: self,
                                                                action: #selector(self.dismissKeyboard))

    private var searchText: String?
    
	override func viewDidLoad() {
		super.viewDidLoad()

        addHandlers()
	}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        collectionView.addGestureRecognizer(gestureRecognizer)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        collectionView.removeGestureRecognizer(gestureRecognizer)
    }

    private func addHandlers() {
        viewModel.insertData = { [weak self] indexPath in
            mainThread {
                self?.collectionView.insertItems(at: [indexPath])
            }
        }

        viewModel.reloadData = { [weak self] in
            mainThread {
                self?.collectionView.reloadData()
            }
        }
    }
    
    @objc
    private func dismissKeyboard() {
        searchBar.endEditing(true)
    }
}

extension AppViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(self.search),
                                               object: nil)
        self.searchText = searchText
        viewModel.clearItems()
        self.perform(#selector(self.search), with: nil, afterDelay: 0.5)
	}
    
    @objc
    private func search() {
        if let query = searchText, query.hasContent {
            viewModel.fetch(query: query)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension AppViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.numberOfItems()
	}
	
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GIFCell", for: indexPath) as! GIFCell
        cell.configure(image: viewModel.item(indexPath))

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfItems() - 3 && viewModel.itemsLoaded {
            search()
        }
    }
}

extension AppViewController: UICollectionViewDelegate {}

extension AppViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // FIXME: investigate
        let screenWidth = UIScreen.main.bounds.width
        let size = screenWidth / 2 - 13

        return CGSize(width: size, height: size)
    }
}

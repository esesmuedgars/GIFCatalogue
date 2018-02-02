//
//  ViewController.swift
//  GifCatalogue
//
//  Created by Edgars Vanags on 18/01/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var collectionView: UICollectionView!
	
    var images = [UIImage?]()
    var searchString: String?
    var loaded = false
    
	override func viewDidLoad() {
		super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        collectionView.addGestureRecognizer(tapGesture)
	}
    
    @objc func hideKeyboard() {
        searchBar.endEditing(true)
    }
}

// - MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.search), object: nil)
        searchString = searchText
        images.removeAll()
        self.perform(#selector(self.search), with: nil, afterDelay: 0.5)
	}
    
    @objc func search() {
        loaded = false
        
        guard let searching = searchString else {
            return
        }
        
        if !searching.isEmpty {
            DispatchQueue.global(qos: .userInitiated).async {
                GifImage.download(forResult: searching, withOffset: self.images.count) { gifImageURLStrings in
                    for url in gifImageURLStrings {
                        self.images.append(UIImage.gifImageFrom(url))
                        print("Image count: \(self.images.count)")
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                    print("Done loading, item count: \(self.images.count)")
                    self.loaded = true
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

// - MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return images.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifImageCell", for: indexPath) as? GifImageCell {
            cell.configureCellWith(gifImage: images[indexPath.row])
            return cell
		} else {
			return UICollectionViewCell()
		}
	}
	
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let size = screenWidth / 2 - 13
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == images.count - 1 && loaded {
            search()
        }
    }
}

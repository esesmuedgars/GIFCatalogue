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
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

// - MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//		if !searchText.isEmpty {
//			GifImage.download(forResult: searchText) { gifImageURLStrings in
//				self.images.removeAll()
//				for url in gifImageURLStrings {
//					self.images.append(UIImage.gifImageFrom(url))
//				}
//				self.collectionView.reloadData()
//			}
//		}
		
//		NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.fireRequest), object: nil)
//
//		DispatchQueue.main.asyncAfter(deadline: .now() + .miliseconds(500)) {
//			self.fireRequest()
//		}
		
		NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
		self.perform(#selector(self.reload(txt:)), with: searchText, afterDelay: 0.5)
	}
	
	@objc func reload(txt: String) {
		print("👋🏼")
		GifImage.download(forResult: txt) { gifImageURLStrings in
			self.images.removeAll()
			for url in gifImageURLStrings {
				self.images.append(UIImage.gifImageFrom(url))
			}
			self.collectionView.reloadData()
		}
	}
	
//	@objc func fireRequest() {
//		print("FIRE! -1")
////				if !searchText.isEmpty {
//					GifImage.download(forResult: searchText) { gifImageURLStrings in
//						self.images.removeAll()
//						for url in gifImageURLStrings {
//							self.images.append(UIImage.gifImageFrom(url))
//						}
//						self.collectionView.reloadData()
//					}
////				}
//	}
}

// - MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
		return CGSize(width: 100, height: 100)
	}
}

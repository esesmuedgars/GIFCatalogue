//
//  ViewController.swift
//  GifCatalogue
//
//  Created by Edgars Vanags on 18/01/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView! // TODO: Remove outlet
	@IBOutlet weak var searchBar: UISearchBar!
	
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		GifImage.download(forResult: "test robot") { gifImageURLStrings in
//			self.imageView.image = UIImage.gifImageFrom(gifImageURLStrings.first!) // FIXME: Replace placeholder image url & input string
//		}
//	}
}

extension ViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if !searchText.isEmpty {
			GifImage.download(forResult: searchText) { gifImageURLStrings in
				if let urlString = gifImageURLStrings.first {
					self.imageView.image = UIImage.gifImageFrom(urlString)
				}
			}
		}
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		print("Stopped")
	}
}

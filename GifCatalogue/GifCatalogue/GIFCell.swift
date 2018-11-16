//
//  GifImageCell.swift
//  GifCatalogue
//
//  Created by Edgars Vanags on 24/01/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import UIKit

class GIFCell: UICollectionViewCell {
	
	@IBOutlet weak var imageView: UIImageView!
	
	func configure(image: UIImage?) {
		imageView.image = image
	}
}

//
//  GifImageCell.swift
//  GifCatalogue
//
//  Created by Edgars Vanags on 24/01/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import UIKit

class GifImageCell: UICollectionViewCell {
	
	@IBOutlet weak var gifImageView: UIImageView!
	
	func configureCellWith(gifImage: UIImage?) {
		gifImageView.image = gifImage
	}
}

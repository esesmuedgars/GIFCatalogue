//
//  GifImageCell.swift
//  GifCatalogue
//
//  Created by Edgars Vanags on 24/01/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import UIKit
import Gifu

@IBDesignable
final class GIFCell: UICollectionViewCell {

    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

	@IBOutlet private weak var imageView: GIFImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.startAnimating()
    }
    
    func configure(data: Data) {
        imageView.prepareForAnimation(withGIFData: data)
        imageView.startAnimatingGIF()
    }
}

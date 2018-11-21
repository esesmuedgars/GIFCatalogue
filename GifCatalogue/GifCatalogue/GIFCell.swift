//
//  GifImageCell.swift
//  GifCatalogue
//
//  Created by Edgars Vanags on 24/01/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import UIKit

@IBDesignable
final class GIFCell: UICollectionViewCell {

    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

	@IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.startAnimating()
        imageView.image = nil
    }

    func configure(url string: String) {
        if let image = CacheManager.shared.cache.get(forKey: string) {
            imageView.image = image
            activityIndicator.stopAnimating()
        } else {
            imageView.gif(url: string) { [weak self] image in
                CacheManager.shared.cache.set(image, forKey: string)
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}

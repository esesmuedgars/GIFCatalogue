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
        imageView.clear()
        activityIndicator.startAnimating()
    }

    func configure(url string: String) {
        if let data = cache.object(forKey: string as NSString) as Data? {
            self.imageView.animate(withGIFData: data)
        } else {
            backgroundThread(qos: .userInteractive) {
                if let data = try? Data(url: string) {
                    mainThread {
                        cache.setObject(data as NSData, forKey: string as NSString)
                        self.imageView.animate(withGIFData: data)
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}

let cache = NSCache<NSString, NSData>()



//
//  Convenience.swift
//  GifCatalogue
//
//  Created by e.vanags on 17/11/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

extension String: Error {}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

func mainThread(_ executable: @escaping () -> Void) {
    DispatchQueue.main.async(execute: executable)
}

func backgroundThread(qos: DispatchQoS.QoSClass = .default, _ executable: @escaping () -> Void) {
    DispatchQueue.global(qos: qos).async(execute: executable)
}

extension String {
    var hasContent: Bool {
        get {
            return !self.isEmpty
        }
    }
}

extension Array {
    var hasContent: Bool {
        get {
            return !self.isEmpty
        }
    }
}

extension Reactive where Base == UICollectionView {
    public func items<S, Cell, O>(cellType: Cell.Type) -> (O) -> (@escaping (Int, S.Iterator.Element, Cell) -> Void) -> Disposable where S : Sequence, S == O.E, Cell : UICollectionViewCell, O : ObservableType {
        return self.items(cellIdentifier: String(describing: cellType), cellType: cellType)
    }
}

extension UIImageView {
    public func gif(url string: String, completionHandler: @escaping (UIImage?) -> Void) {
        backgroundThread(qos: .userInteractive) {
            let image = UIImage.gif(url: string)
            mainThread {
                self.image = image
                completionHandler(image)
            }
        }
    }
}

extension NSCache where KeyType == NSString, ObjectType == UIImage {
    func get(forKey key: String) -> UIImage? {
        return object(forKey: NSString(string: key))
    }

    func set(_ image: UIImage?, forKey key: String) {
        if let image = image {
            setObject(image, forKey: NSString(string: key))
        }
    }
}

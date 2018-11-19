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

func backgroundThread(qos: DispatchQoS.QoSClass, _ executable: @escaping () -> Void) {
    DispatchQueue.global(qos: qos).async(execute: executable)
}

extension String {
    var hasContent: Bool {
        get {
            return !self.isEmpty
        }
    }
}

extension Data {
    init(url string: String) throws {
        guard let url = URL(string: string) else {
            throw "Unable to initiate URL structure from \(string)."
        }
        try self.init(contentsOf: url)
    }
}

extension Reactive where Base == UICollectionView {
    public func items<S, Cell, O>(cellType: Cell.Type) -> (O) -> (@escaping (Int, S.Iterator.Element, Cell) -> Void) -> Disposable where S : Sequence, S == O.E, Cell : UICollectionViewCell, O : ObservableType {
        return self.items(cellIdentifier: String(describing: cellType), cellType: cellType)
    }
}

extension UIImageView {
    func clear() {
        image = nil
    }
}

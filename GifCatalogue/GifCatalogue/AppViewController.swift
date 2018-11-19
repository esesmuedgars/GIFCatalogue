//
//  AppViewController.swift
//  GifCatalogue
//
//  Created by Edgars Vanags on 18/01/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class AppViewController: UIViewController {

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var collectionView: UICollectionView!

    private lazy var viewModel = AppViewModel()
    private lazy var gestureRecognizer = UITapGestureRecognizer(target: self,
                                                                action: #selector(self.dismissKeyboard))
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        addHandlers()
	}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        collectionView.addGestureRecognizer(gestureRecognizer)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        collectionView.removeGestureRecognizer(gestureRecognizer)
    }

    private func addHandlers() {
        textField.rx.text.orEmpty.skip(1)
            .debounce(0.5, scheduler:  MainScheduler.instance)
            .flatMap { [unowned self] query -> Observable<[Data]> in
                if query.hasContent {
                    return self.viewModel.fetch(query: query)
                } else {
                    return self.viewModel.clearItems()
                }
            }.bind(to: collectionView.rx.items(cellIdentifier: "GIFCell")) { (_, data, cell: GIFCell) in
                cell.configure(data: data)
            }.disposed(by: viewModel.disposeBag)
    }
    
    @objc
    private func dismissKeyboard() {
        textField.endEditing(true)
    }
}

// MARK: Delegate

extension AppViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfItems() - 1 && viewModel.itemsLoaded {
            textField.sendActions(for: .editingDidEnd)
        }
    }
}

// MARK: DelegateFlowLayout

extension AppViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width - 10) / 2

        return CGSize(width: size, height: size)
    }
}

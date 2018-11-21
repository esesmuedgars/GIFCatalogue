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
    @IBOutlet private weak var noDataLabel: UILabel!

    private lazy var viewModel = AppViewModel()
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        addHandlers()
	}

    private func addHandlers() {
        textField.rx.text.orEmpty.skip(1)
            .debounce(0.5, scheduler: MainScheduler.instance)
            .flatMapLatest { [viewModel] query -> Observable<[String]> in
                if viewModel.shouldClearItems {
                    viewModel.clearItems()
                }

                return viewModel.fetchItems(query: query)
            }.bind(to: collectionView.rx.items(cellType: GIFCell.self)) { (_, source, cell) in
                cell.configure(url: source)
            }.disposed(by: viewModel.disposeBag)

        viewModel.observableItems.map { $0.hasContent }
            .bind(to: noDataLabel.rx.isHidden)
            .disposed(by: viewModel.disposeBag)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        collectionView.collectionViewLayout.invalidateLayout()
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard textField.isFirstResponder else { return }
        
        textField.resignFirstResponder()
    }
}

// MARK: Collection Delegate

extension AppViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfItems() - 1 && viewModel.didLoadItems {
            viewModel.shouldClearItems = false
            textField.sendActions(for: .editingDidEnd)
        }
    }
}

// MARK: Collection DelegateFlowLayout

extension AppViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width - 30) / 2

        return CGSize(width: size, height: size)
    }
}

//
//  ViewController.swift
//  GifCatalogue
//
//  Created by Edgars Vanags on 18/01/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		GifImage.download { gifs in
			print(gifs)
		}
	}
}


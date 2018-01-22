//
//  GifImageModule.swift
//  GifCatalogue
//
//  Created by Edgars Vanags on 22/01/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import Foundation

typealias DownloadComplete = ([Any]) -> ()

let URL_HOST = "https://api.giphy.com"
let URL_PATH = "/v1/gifs/search"

// Documentation reference
// developers.giphy.com/docs/#operation--gifs-search-get

struct GifImage {
	static func download(completed: @escaping DownloadComplete) {
		let url = URL(string: URL_HOST + URL_PATH + "?q=funny+cat&api_key=XVROvtKUUF7ctQK9rZQgX54N9RiRY2V8")!
		
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			do {
				guard let data = data, error == nil else {
					print(error!.localizedDescription)
					throw NSError(domain: error!.localizedDescription, code: 400)
				}

				if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
					print("HTTP GET successful request status code should be 200, but is \(httpStatus.statusCode)")
					throw NSError(domain: "Did not recieve status code 200", code: httpStatus.statusCode)
				}
				
				if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
				let data = json["data"] as? [[String: Any]] {
					for item in data {
						// TODO: Consider retrieving only id and concatinating new URL for image GET request
						if let images = item["images"] as? [String: Any],
						let imageObject = images["fixed_width"] as? [String: Any],
						let imageURLString = imageObject["url"] as? String {
							// TODO: Make use of gif image URL
							print(imageURLString)
						}
					}
				}
				
				completed([Any]()) // FIXME: Add array of gif images which to pass to ViewController
			} catch {
				print(error.localizedDescription)
			}
		}
		task.resume()
	}
}

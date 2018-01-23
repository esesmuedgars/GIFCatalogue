//
//  GifImageModule.swift
//  GifCatalogue
//
//  Created by Edgars Vanags on 22/01/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import Foundation

struct GifImage {
	
	static func download(forResult queryString: String, completed: @escaping DownloadComplete) {
		guard let pathForStrings = Bundle.main.path(forResource: "Strings", ofType: "stringsdict") else {
			return
		}
		var URLStringsDictionary = NSDictionary(contentsOfFile: pathForStrings) as! [String: String]
		
		if let pathForConfig = Bundle.main.path(forResource: "Config", ofType: "plist"),
			let configDictionary = NSDictionary(contentsOfFile: pathForConfig) as?  [String: String] {
			
			// TODO: Consider making limit non-static, hard-coded value
			let URLString = "\(URLStringsDictionary["URL_HOST"]!)\(URLStringsDictionary["URL_PATH"]!)?\(URLStringsDictionary["URL_QUERY"]!)\(queryString.replacingOccurrences(of: " ", with: "+"))&\(URLStringsDictionary["URL_LIMIT"]!)5&\(URLStringsDictionary["URL_API_KEY"]!)\(configDictionary["API_KEY"]!)"
			let url = URL(string: URLString)!
			
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
					
					var imageURLStrings = [String]()
					
					if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
						let data = json["data"] as? [[String: Any]] {
						for item in data {
							if let images = item["images"] as? [String: Any],
								let imageObject = images["fixed_width"] as? [String: Any],
								let imageURLString = imageObject["url"] as? String {
								imageURLStrings.append(imageURLString)
							}
						}
					}
					
					DispatchQueue.main.async {
						completed(imageURLStrings)
					}
				} catch {
					print(error.localizedDescription)
				}
			}
			task.resume()
		}
	}
	
}

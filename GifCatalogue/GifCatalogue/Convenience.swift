//
//  Convenience.swift
//  GifCatalogue
//
//  Created by e.vanags on 17/11/2018.
//  Copyright © 2018 edgarsvanags. All rights reserved.
//

import Foundation

extension String: Error {}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

func mainThread(_ executable: @escaping () -> Void) {
    DispatchQueue.main.async(execute: executable)
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

//
//  ImageCache.swift
//  AppDemo
//
//  Created by Daniel Bonates on 06/12/21.
//

import UIKit

final class ImageCache {

    private static let appImageFolder = "images"

    private static var cacheURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("cache")
    }

    static func getImage(for url: URL, completion: @escaping (UIImage?) -> Void) {

        let destinationPath = cacheURL.appendingPathComponent(url.lastPathComponent)

        if FileManager.default.fileExists(atPath: destinationPath.path) {

            if let image = UIImage(contentsOfFile: destinationPath.path) {

                completion(image)
                return
            } else {
                print("the path \(destinationPath) is fine, but no image found")
                return
            }

        }

        let imgResource = Resource<UIImage>(request: URLRequest(url: url), parse: { data in

            let destinationURL = cacheURL.appendingPathComponent(url.lastPathComponent)

            try? FileManager.default.createDirectory(
                atPath: self.cacheURL.path,
                withIntermediateDirectories: true,
                attributes: [:])

            do {
                try data.write(to: destinationURL)
            } catch let error {
                print(error.localizedDescription)

            }

            return UIImage(data: data)
        })

        WebService.load(resource: imgResource, completion: { image in
            completion(image)
            return
        })

    }

    // util - clear the cache
    static func clearCache() {
        let fileManager = FileManager.default

        var isDir = ObjCBool(false)
        guard fileManager.fileExists(atPath: cacheURL.path, isDirectory: &isDir) else {
            print("nothing to clear")
            return
        }

        do {
            let files = try fileManager.contentsOfDirectory(atPath: cacheURL.path)
            for file in files {

                try fileManager.removeItem(atPath: cacheURL.path + "/" + file)
            }
        } catch let error as NSError {
            print("Could not clear temp folder: \(error.debugDescription)")
        }
    }
}

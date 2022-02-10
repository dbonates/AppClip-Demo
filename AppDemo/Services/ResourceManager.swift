//
//  ResourceManager.swift
//  AppDemo
//
//  Created by Daniel Bonates on 09/12/21.
//

import UIKit


final class ResourceManager {

    static func loadReviews(completion: @escaping (Result<[ReviewResource], APIError>) -> Void) {
        let url = URL(string: "https://gist.githubusercontent.com/dbonates/5e3471f086a821360386e5228e52aae7/raw/5b84bf93bd207c3f59f3f83b46fefb1810966e15/ratings.json")!
        let request = URLRequest(url: url)

        let reviewResource = Resource<[ReviewResource]>(request: request) { data in

            do {
                let reviews = try JSONDecoder().decode([ReviewResource].self, from: data)
                return reviews
            } catch {
                print(APIError.invalidResponseFormat.errorMessage)
            }
            return nil
        }

        WebService.load(resource: reviewResource) { review in
            completion(.success(review ?? []))
        }

    }

    static func loadRandomImages(completion: @escaping (Result<[URL], APIError>) -> Void) {

        // random image from UNSplash
        let url = URL(string: "https://api.unsplash.com/photos/random?orientation=squarish&content_filter=high&query=Restaurant&count=6")!
        var request = URLRequest(url: url)
        request.addValue("v1", forHTTPHeaderField: "Accept-Version")
        request.addValue("Client-ID ZyT27QklmRhkMRi5vl0fCFiFDNoRKczrU16ZYHnPowo", forHTTPHeaderField: "Authorization")

        let randomImage = Resource<[URL]>(request: request) { data in

            // this data is a json returned from Unsplash
            do {
                let imageSources = try JSONDecoder().decode([UnsplashImageSource].self, from: data)
                let allThumbsURLs = imageSources.map { $0.thumbURL }
                return allThumbsURLs.compactMap { $0 }
            } catch let error {
                print("error decoding image list: \(error.localizedDescription)")
            }

            return nil
        }

        WebService.load(resource: randomImage) { urls in

            DispatchQueue.main.async {
                completion(.success(urls ?? []))
            }
        }
    }
}

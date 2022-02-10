//
//  WebService.swift
//  AppDemo
//
//  Created by Daniel Bonates on 06/12/21.
//

import Foundation
import UIKit

final class WebService {
    static func load<T>(resource: Resource<T>, completion: @escaping (T?) -> Void) {
        (URLSession.shared.dataTask(with: resource.request, completionHandler: { data, response, error in
            guard error == nil else { print(error.debugDescription); return }
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            else {
                print("request failed.")
                return
            }
            guard let data = data else { completion(nil); return }
            completion(resource.parse(data))
        })).resume()
    }
    
    static func loadLocal<T>(resource: Resource<T>, completion: @escaping (T?) -> ()) {
        guard let url = resource.request.url else { return }
        
        do {
            let data = try Data(contentsOf: url)
            completion(resource.parse(data))
        } catch let error {
            print(error.localizedDescription)
            completion(nil)
        }
    }
}

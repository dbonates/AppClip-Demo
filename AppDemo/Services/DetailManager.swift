//
//  DetailManager.swift
//  AppDemo
//
//  Created by Daniel Bonates on 14/12/21.
//

import Foundation

protocol DetailManagerDelegate: AnyObject {
    func didLoadedDetails(from locationDetail: LocationDetail)
    func didFetchedThumbnailsURLs()
}

class DetailManager: NSObject {
    
    weak var delegate: DetailManagerDelegate?
    
    var selectedLocationDetails: LocationDetail = .empty {
        didSet {
            delegate?.didLoadedDetails(from: selectedLocationDetails)
        }
    }
        
    var thumbImagesURLs = [URL]() {
        didSet {
            updateThumbnailsCollectionView()
        }
    }
    
    
    static func setupThumbnails(completion: @escaping ([URL]?)->()) {

        ResourceManager.loadRandomImages { result in
            switch result {
            case .failure:
                completion(nil)
            case .success(let urls):
                DispatchQueue.main.async {
                    completion(urls)
                }
            }
        }
    }

    func updateThumbnailsCollectionView() {
        delegate?.didFetchedThumbnailsURLs()
    }

}

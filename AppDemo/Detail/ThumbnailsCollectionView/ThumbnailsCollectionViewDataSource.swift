
//  ThumbnailsCollectionViewDataSource.swift
//  AppDemo
//
//  Created by Daniel Bonates on 09/12/21.
//

import UIKit

class ThumbnailsCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    var thumbURLs = [URL]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbURLs.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
                as? ThumbnailsCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.displayRandomImage(from: thumbURLs[indexPath.item])
        return cell
    }

}

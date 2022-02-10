//
//  HomeViewControllerDataSource.swift
//  AppDemo
//
//  Created by Daniel Bonates on 14/12/21.
//

import Foundation
import UIKit

class HomeViewControllerDataSource: NSObject, UICollectionViewDataSource {
    
    var locationsManager: LocationsManager!

    convenience init(with locationManager: LocationsManager) {
        self.init()
        self.locationsManager = locationManager
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        locationsManager.locations.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath)
                as? ListCellUICollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: locationsManager.locations[indexPath.item])
        return cell
    }
}


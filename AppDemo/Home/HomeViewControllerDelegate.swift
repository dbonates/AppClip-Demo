//
//  HomeViewControllerDelegate.swift
//  AppDemo
//
//  Created by Daniel Bonates on 14/12/21.
//

import Foundation
import UIKit

class HomeViewControllerDelegate: NSObject, UICollectionViewDelegate, PinterestLayoutDelegate {
    
    var locationsManager: LocationsManager!

    convenience init(with locationManager: LocationsManager) {
        self.init()
        self.locationsManager = locationManager
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        locationsManager.selectedLocation = locationsManager.locations[indexPath.item]
    }
    
    
    // MARK: - Fancy PinterestLayoutDelegate
    func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        let space: Float = 5
        let itemWidth = (Float(collectionView.bounds.width)-(space*3))/2
        let maxHeight = itemWidth * 1.65
                
        return CGFloat(Float.random(min: itemWidth, max: maxHeight))
    }
    
}

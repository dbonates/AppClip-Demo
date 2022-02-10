//
//  Location.swift
//  AppDemo
//
//  Created by Daniel Bonates on 06/12/21.
//

import Foundation

struct Location {
    let id: Int
    let name: String
    let type: String
    let review: Float
    let imageURL: URL?
}

extension Location {
    
    var isFavorite: Bool {
        return SettingsManager.isFavorite(self.id)
    }
    
    func toogleFavorite() {
        let currentFavoriteStatus = isFavorite
        let newFavorite = !currentFavoriteStatus
        SettingsManager.setFavorite(self.id, isFavorite: newFavorite)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FavoritesUpdated"), object: nil)
    }
}


extension Location {
    static let empty: Location = {
        return Location(id: 0, name: "", type: "", review: 0, imageURL: nil)
    }()
}

extension Location {
    init?(from locationSource: LocationSource) {
        self.id = locationSource.id
        self.name = locationSource.name
        self.type = locationSource.type
        self.review = locationSource.review
        self.imageURL = URL(string: "https://dboserver.herokuapp.com/images/\(id).jpg")!
    }
}


// Decodable from API
struct LocationsSourceArray: Decodable {
    let listLocations: [LocationSource]
}


struct LocationSource: Decodable {
    let id: Int
    let name: String
    let type: String
    let review: Float
}
